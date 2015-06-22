SUMMARY = "Custom iptables rules "

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"


SRC_URI="file://iptables"

do_install() {
    install -d ${D}${sysconfdir}/sysconfig/
    install -m 0644 ${WORKDIR}/iptables ${D}${sysconfdir}/sysconfig/
}



