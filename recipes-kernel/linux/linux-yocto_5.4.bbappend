require linux-yocto-nxp-s32g2xx.inc

KBRANCH_nxp-s32g2xx  = "v5.4/standard/nxp-s32g2xx"

LINUX_VERSION_nxp-s32g2xx ?= "5.4.x"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:" 
SRC_URI += " \
	file://s32g-add-wdt.cfg \
	file://s32g-add-hse-uio-driver.cfg \
	file://0001-regmap-regmap-debugfs-Set-debugfs_name-to-NULL-after.patch \
	file://0001-dts-s32g-bb3-change-gigabit-phys-addresses.patch \
	file://0002-dts-s32-gen1-Fix-SIUL2-ranges.patch \
	file://0003-gpio-siul-s32gen1-Add-PM-callbacks.patch \
	file://0004-Remove-S32V344-platform.patch \
	file://0005-drivers-dwmac-s32cc-Correct-TX-clock-name.patch \
	file://0006-gpio-s32-gen1-Fix-double-free.patch \
	file://0007-clk-s32-gen1-Remove-hard-coded-sizes-for-clock-PLLs.patch \
	file://0008-rtc-s32gen1-Add-sentinel-to-device-ID-list.patch \
	file://0009-serial-fsl_linflexuart-initialize-init_lock-earlier.patch \
	file://0010-spi-spi-fsl-dspi-restrict-register-range-for-regmap-.patch \
	file://0011-dts-bindings-srma-Add-llce-sram-compatible.patch \
	file://0012-sram-Add-LLCE-sram-compatible.patch \
	file://0013-dt-bindings-s32g274a-Add-LLCE-clocks-indexes.patch \
	file://0014-clk-s32g274a-Add-LLCE-clocks.patch \
	file://0015-doc-Add-documentation-for-NXP-LLCE-Firmware-Loader.patch \
	file://0016-doc-Add-documentation-for-NXP-LLCE-Mailbox.patch \
	file://0017-doc-Add-documentation-for-NXP-LLCE-CAN.patch \
	file://0018-dt-bindings-s32g274a-Add-LLCE-CAN-pinmuxing-defines.patch \
	file://0019-dts-s32g274a-Add-LLCE-nodes.patch \
	file://0020-driver-Add-LLCE-core-driver.patch \
	file://0021-drivers-mailbox-Add-LLCE-CAN-mailbox.patch \
	file://0022-drivers-can-Add-LLCE-CAN-driver.patch \
	file://0023-sram-Add-power-management-operations.patch \
	file://0024-driver-llce-core-Add-power-management-operations.patch \
	file://0025-driver-llce-mailbox-Add-power-management-operations.patch \
	file://0026-driver-llce-can-Add-power-management-operations.patch \
	file://0027-s32gen1-Reorganize-input-and-output-siul2-pads.patch \
	file://0028-dts-s32g274-introduce-fsl-s32g274a-siul2-gpio.patch \
	file://0029-dts-devicetree-Add-fsl-s32g274a-siul2-gpio-to-gpio-s.patch \
	file://0030-gpio-s32gen1-Use-16-bits-input-output-pads.patch \
	file://0031-gpio-siul2-Disable-cache-on-ipad-regmap.patch \
	file://0032-clk-clk-plldig-Use-break-after-each-switch-label.patch \
	file://0033-gpio-s32-gen1-Don-t-clear-IRQ-type-when-masking-a-GP.patch \
	file://0034-dts-bluebox3-enable-LLCE.patch \
	file://0035-sac58r_wdt-Introduce-a-flag-to-continue-timer-during.patch \
	file://0036-drivers-clocksource-Include-FSL-STM-driver-timer-in-.patch \
	file://0037-clocksource-drivers-fsl_stm-Rename-the-file-for-cons.patch \
	file://0038-dts-s32-gen1-Correct-PMU-interrupt.patch \
	file://0039-dma-fsl-edma-Disable-request-only-when-no-hw-request.patch \
	file://0040-serial-fsl_linflex-Fix-console-freeze.patch \
	file://0041-serial-fsl_linflex-Fix-CONFIG_DMA_API_DEBUG-reported.patch \
	file://0042-can-llce-Don-t-report-EPROBE_DEFER-errors.patch \
	file://0043-llce-can-Use-NAPI-on-RX.patch \
	file://0044-rtc-s32gen1-Simplify-probe-callback.patch \
	file://0045-rtc-s32gen1-Implement-read_time-callback.patch \
	file://0046-rtc-s32gen1-Implement-set_time-callback.patch \
	file://0047-dts-s32-gen1-Remove-memory-nodes.patch \
	file://0048-s32gen1-fsl-qspi-Add-pinmuxing-for-QSPI.patch \
	file://0049-s32g-clk-Add-SAR_ADC-clock-over-SCMI.patch \
	file://0050-s32gen1-qspi-Improve-QSPI-read-performance.patch \
	file://0051-s32gen1-fsl-qspi-Map-entire-AHB-buffer-at-first-read.patch \
	file://0052-s32gen1-fsl-quadspi-Map-AHB-buffer-using-ioremap_cac.patch \
	file://0053-s32g274a-evb-qspi-Update-clock-speed-according-to-So.patch \
	file://0054-dts-s32-gen1-Add-timestamp-clock-to-kernel.patch \
	file://0055-dts-s32-gen1-Add-timestamp-clock-muxes-to-kernel.patch \
	file://0056-dts-s32-gen1-Add-timestamp-clock-to-PFE-device-tree.patch \
	file://0057-s32-flexcan-Enable-entire-frame-arbitration-field-co.patch \
	file://0058-linflex-Add-clocks-to-suspend-and-resume-callbacks.patch \
	file://0059-clk-s32gen1-Avoid-out-of-bounds-access.patch \
	file://0060-mailbox-llce-Limit-the-warning-messages.patch \
	file://0061-can-llce-Propagate-error-conditions-to-the-CAN-stack.patch \
	file://0062-serial-linflex-Disable-DMA-in-linflex_flush_buffer.patch \
	file://0063-serial-linflex-Update-RXEN-TXEN-outside-INITM.patch \
	file://0064-serial-linflex-Correct-startup-locking.patch \
	file://0065-serial-linflex-Stop-any-dma-transfer-during-INITM.patch \
	file://0066-serial-linflex-Make-sure-fifo-is-empty-when-entering.patch \
	file://0067-serial-linflex-Revert-earlycon-workaround.patch \
	file://0068-serial-linflex-Revert-restart-workaround.patch \
	file://0069-serial-linflex-Check-FIFO-full-before-writing.patch \
	file://0070-serial-linflex-Fix-kgdb.patch \
	file://0071-s32gen1-mmc-Enable-MMC_HS400-mode.patch \
	file://0072-s32v234-mmc-Set-SDHCI_QUIRK2_NO_1_8_V-using-the-devi.patch \
	file://0073-dts-s32g27a-pfe-update-properties-for-0.9.3-driver.patch \
        file://0074-dts-s32g27a-pfe-refactor-reserved-memory-across-targ.patch \
        file://0075-dts-s32g27a-pfe-refactor-interface-HIF-number.patch \
        file://0076-Documentation-dt_bindings-update-pfeng-driver.patch \
        file://0077-dts-s32g27a-pfe-add-PFE-slave-driver-entry-example.patch \
        file://0078-pcie-Update-PCIe-mappings-in-S32-Gen1-device-trees.patch \
        file://0080-pcie-s32r45-Enable-PCIe0.patch \
        file://0081-pcie-s32gen1-Remove-SoC-version-check-when-enabling-.patch \
        file://0082-pcie-s32gen1-Fix-RC-enumeration.patch \
        file://0083-net-phy-add-AQR113c-support.patch \
	file://0084-hse-user-space-driver-support.patch \
"
