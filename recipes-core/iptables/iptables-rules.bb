inherit update-rc.d

SUMMARY = "Custom iptables rules "

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"


SRC_URI="file://iptables-rules; \
         file://iptables"


INITSCRIPT_NAME = "iptables"
INITSCRIPT_PARAMS = "start 99 5 2 . stop 20 0 1 6 ."

do_install() {
    install -m 0644 -d ${D}${sysconfdir}/sysconfig/
    install -m 0644 -d ${D}${sysconfdir}/init.d/
    install -m 0644 ${WORKDIR}/iptables-rules ${D}${sysconfdir}/sysconfig/
    install -m 0744 ${WORKDIR}/iptables ${D}${sysconfdir}/init.d/
}



