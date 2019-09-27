FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://timesyncd.conf \
	    file://eth0.network"

do_install_append() {
    install -m 0644 ${WORKDIR}/timesyncd.conf ${D}${sysconfdir}/systemd
    install -m 0644 ${WORKDIR}/eth0.network ${D}${sysconfdir}/systemd/network
}
