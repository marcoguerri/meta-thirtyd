FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://meta_thirtyd_config"

do_kernel_configme_prepend() {
    install -m 0644 ${WORKDIR}/meta_thirtyd_config ${S}/arch/${ARCH}/configs/${KERNEL_DEFCONFIG}
}
