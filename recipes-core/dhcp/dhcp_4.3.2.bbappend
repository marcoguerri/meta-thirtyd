inherit update-rc.d

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"


SRC_URI += "file://default-server \
            file://dhcpd.conf  \
            "

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SYSTEMD_AUTO_ENABLE_${PN}-server="enable"

INITSCRIPT_PACKAGES = "${PN}-server"
INITSCRIPT_NAME_${PN}-server = "${PN}-server"
INITSCRIPT_PARAMS_${PN}-server = "start 99 5 2 . stop 20 0 1 6 ."
