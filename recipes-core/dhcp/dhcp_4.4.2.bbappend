# For documentation about the update-rc.d class:
# http://docs.openembedded.ru/update-rc-d_class.html

inherit update-rc.d

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SYSTEMD_AUTO_ENABLE_${PN}-server="enable"
