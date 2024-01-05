require optee-os-nxp.inc

do_compile:nxp-s32g() {
    for plat in ${OPTEE_PLAT_FLAVORS}; do
        if [ "${HSE_SEC_ENABLED}" = "1" ]; then
            if [ "$plat" = "s32g2" ]; then
                fw_version="${HSE_FW_VERSION_S32G2}"
            else
                fw_version="${HSE_FW_VERSION_S32G3}"
            fi
            oe_runmake -C ${S} PLATFORM_FLAVOR=$plat CFG_CRYPTO_DRIVER=y \
                       HSE_FWDIR=${HSE_LOCAL_FIRMWARE_DIR}/${fw_version} \
                       O=${B}/$plat all
        else
            oe_runmake -C ${S} PLATFORM_FLAVOR=$plat O=${B}/$plat all
        fi
    done
}

do_install:nxp-s32g() {
    for plat in ${OPTEE_PLAT_FLAVORS}; do
        #install core in firmware
        install -d ${D}${nonarch_base_libdir}/firmware/$plat
        install -m 644 ${B}/$plat/core/*.bin ${B}/$plat/core/tee.elf ${D}${nonarch_base_libdir}/firmware/$plat
    done
}

do_deploy:nxp-s32g() {
    for plat in ${OPTEE_PLAT_FLAVORS}; do
        install -d ${DEPLOYDIR}/${MLPREFIX}optee/$plat
        install -m 644 ${D}${nonarch_base_libdir}/firmware/$plat/* ${DEPLOYDIR}/${MLPREFIX}optee/$plat
    done
}