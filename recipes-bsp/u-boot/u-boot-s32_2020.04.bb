require recipes-bsp/u-boot/u-boot.inc

DESCRIPTION = "U-boot provided by NXP with focus on S32 chipsets"
PROVIDES += "u-boot"

LICENSE = "GPLv2 & BSD-3-Clause & BSD-2-Clause & LGPL-2.0 & LGPL-2.1"
LIC_FILES_CHKSUM = " \
    file://Licenses/gpl-2.0.txt;md5=b234ee4d69f5fce4486a80fdaf4a4263 \
    file://Licenses/bsd-2-clause.txt;md5=6a31f076f5773aabd8ff86191ad6fdd5 \
    file://Licenses/bsd-3-clause.txt;md5=4a1190eac56a9db675d58ebe86eaf50c \
    file://Licenses/lgpl-2.0.txt;md5=5f30f0716dfdd0d91eb439ebec522ec2 \
    file://Licenses/lgpl-2.1.txt;md5=4fbd65380cdd255951079008b364516c \
"

INHIBIT_DEFAULT_DEPS = "1"
DEPENDS_append = " libgcc virtual/${TARGET_PREFIX}gcc python3 dtc-native bison-native"

inherit nxp-u-boot-localversion

SRC_URI_prepend = "git://source.codeaurora.org/external/autobsps32/u-boot;protocol=https;branch=release/bsp29.0-2020.04 "

SRC_URI += " \
    file://0001-configs-s32g274aevb-add-HSE_SECBOOT-config-for-HSE-t.patch \
    file://0001-secboot-add-key-store-status-check-point-after-sys_i.patch \
    file://0001-Make-s32g274ardb2-and-s32g2xxaevb-support-ostree.patch \
    file://0001-scripts-mailmapper-python2-python3.patch \
    file://bsp30/0001-s32gen1-GICR-has-different-offset-on-emulator.patch \
    file://bsp30/0002-s32g398aemu-On-emulator-only-1G-of-DDR-is-available.patch \
    file://bsp30/0003-s32g398a-fdt-Apply-memory-fixups.patch \
    file://bsp30/0004-s32-Don-t-enable-caches-for-secondary-cores.patch \
    file://bsp30/0005-s32-Add-functions-to-provide-cpu_pos_mask-per-cluste.patch \
    file://bsp30/0006-s32-gen1-GPR-add-function-to-check-A53-lockstep-stat.patch \
    file://bsp30/0007-s32-lockstep-export-CPUs-mask-depending-on-the-A53-l.patch \
    file://bsp30/0008-s32-gen1-ncore-check-cluster-status-also-for-S32G-de.patch \
    file://bsp30/0009-s32-cleanup-remove-unused-GPR06-defines.patch \
    file://bsp30/0010-s32g274abluebox3-reset-VR5510-FLT_ERR_CNT-counter.patch \
    file://bsp30/0011-s32g274abluebox3-fix-build-warning-for-vr5510_reset_.patch \
    file://bsp30/0012-s32g274a-Add-driver-as-part-of-LPDDR4-ERR050543.patch \
    file://bsp30/0013-s32gen1-Fix-guarding-PCIE_S32GEN1-support.patch \
    file://bsp30/0014-e1000-Add-config-dependency-for-E1000-on-PCI.patch \
"

SRCREV = "61b2dc53d2b6655e5d629da16132ccd72907f83e"
SRC_URI[sha256sum] = "4e80caf195787c76639675712492230d090fe2eb435fd44491d653463485e30c"

SCMVERSION = "y"
LOCALVERSION = ""
PACKAGE_ARCH = "${MACHINE_ARCH}"
UBOOT_INITIAL_ENV = ""

USRC ?= ""
S = '${@oe.utils.conditional("USRC", "", "${WORKDIR}/git", "${USRC}", d)}'

# Enable Arm Trusted Firmware
SRC_URI += " \
    ${@bb.utils.contains('ATF_S32G_ENABLE', '1', 'file://0001-defconfig-add-support-of-ATF-for-rdb2-boards.patch', '', d)} \
"

# For now, only rdb2 boards support ATF, this function will be fixed when new ATF supported boards added.
do_install_append() {

    if [ -n "${ATF_S32G_ENABLE}" ]; then
        unset i j
        install -d ${DEPLOY_DIR_IMAGE}
        for config in ${UBOOT_MACHINE}; do
            i=$(expr $i + 1);
            for type in ${UBOOT_CONFIG}; do
                j=$(expr $j + 1)
                if  [ $j -eq $i ]; then
                        if [ "$type" = "${ATF_SUPPORT_TYPE}" ]; then
                            cp ${B}/${config}/u-boot.bin ${DEPLOY_DIR_IMAGE}/u-boot.bin
                            install -d ${DEPLOY_DIR_IMAGE}/tools
                            cp ${B}/${config}/tools/mkimage ${DEPLOY_DIR_IMAGE}/tools/mkimage
                            break
                        fi
                fi
            done
            unset j
        done
        unset i
    fi
}

# Modify the layout of u-boot to adding hse support using the following script.
# Currentlly, the board version of EVB is rev 1.0 and RDB2 is rev 2.0, they need
# different hse firmware version to coorperate with the board version, and these
# two boards will use same board version in future.

HSE_LOCAL_FIRMWARE_EVB_BIN ?= ""
HSE_LOCAL_FIRMWARE_RDB2_BIN ?= ""

do_compile_append() {

    unset i j
    for config in ${UBOOT_MACHINE}; do
	cp ${B}/tools/s32gen1_secboot.sh ${B}/${config}/tools/s32gen1_secboot.sh
        chmod +x ${B}/${config}/tools/s32gen1_secboot.sh

	i=$(expr $i + 1);
	for type in ${UBOOT_CONFIG}; do
		j=$(expr $j + 1)
		if  [ $j -eq $i ]; then

			if [ "${config}" = "${S32G274AEVB_UBOOT_DEFCONFIG_NAME}" ]; then
				if [ -n "${HSE_LOCAL_FIRMWARE_EVB_BIN}" ] && [ -e "${HSE_LOCAL_FIRMWARE_EVB_BIN}" ]; then
					${B}/${config}/tools/s32gen1_secboot.sh -k ./keys_hse -d ${B}/${config}/u-boot-hse-${type}.s32 --hse ${HSE_LOCAL_FIRMWARE_EVB_BIN}
					cp ${B}/${config}/u-boot-hse-${type}.s32 ${B}/${config}/u-boot.s32
					cp ${B}/${config}/u-boot-hse-${type}.s32 ${B}/${config}/u-boot-${type}.bin
				fi
			else
				if [ -n "${HSE_LOCAL_FIRMWARE_RDB2_BIN}" ] && [ -e "${HSE_LOCAL_FIRMWARE_RDB2_BIN}" ]; then
					${B}/${config}/tools/s32gen1_secboot.sh -k ./keys_hse -d ${B}/${config}/u-boot-hse-${type}.s32 --hse ${HSE_LOCAL_FIRMWARE_RDB2_BIN}
					cp ${B}/${config}/u-boot-hse-${type}.s32 ${B}/${config}/u-boot.s32
					cp ${B}/${config}/u-boot-hse-${type}.s32 ${B}/${config}/u-boot-${type}.bin
				fi
			fi
		fi
	done
	unset j
    done
    unset i
}

COMPATIBLE_MACHINE_nxp-s32g2xx = "nxp-s32g2xx"
