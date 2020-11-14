SUMMARY = "Secure rlogin/rsh/rcp/telnet replacement"
DESCRIPTION = "Ovverride sshd_configuration"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI+="file://sshd_banner; \
          file://authorized_keys"

do_install_append () {
    install -m 0644 ${WORKDIR}/sshd_banner ${D}${sysconfdir}/ssh/sshd_banner

    install -d ${D}${sysconfdir}/
    install -m 0644 ${WORKDIR}/authorized_keys ${D}${sysconfdir}/
}


