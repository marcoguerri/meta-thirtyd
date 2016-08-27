inherit autotools

SUMMARY = "lighttpd web server" 
PV="1.4.41"

LICENSE = "GPL-3.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-3.0;md5=c79ff39f19dfec6d293b95dea7b07891"

S="${WORKDIR}/lighttpd-${PV}"

SRC_URI="http://download.lighttpd.net/lighttpd/releases-1.4.x/lighttpd-${PV}.tar.gz \
         file://lighttpd.conf"

SRC_URI[md5sum] = "6c11ce169169f0e43ee0d9986a067db8"
SRC_URI[sha256sum] = "8a5749e218237fafc3119dd8a4fcf510ea728728b3fcf1193fcad7209be4b6d7"

DEPENDS_${PN}="libbz2 \
               libevent \
               pkg-config"


do_configure() {
    oe_runconf
}
do_install() {
    oe_runmake install
    install -m 644 ${WORKDIR}/lighttpd.conf ${D}${sysconfdir}/lighttpd.conf 
}

