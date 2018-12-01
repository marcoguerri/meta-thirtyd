SUMMARY = "Custom files related to rpi firmwares"
DESCRIPTION = "Custom recipe that defines custom cmdline.txt for kernel command line parameters"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI += "file://cmdline.txt"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

do_deploy_append() {
    cp ${WORKDIR}/cmdline.txt ${DEPLOYDIR}/${PN}
}


