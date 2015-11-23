SUMMARY = "DynDns client"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

PV="3.8.3"
PR="r0"

RDEPENDS_${PN}="perl"

S="${WORKDIR}/ddclient-${PV}"

SRC_URI="http://netcologne.dl.sourceforge.net/project/ddclient/ddclient/ddclient-${PV}.tar.bz2"

SRC_URI[md5sum] = "3b426ae52d509e463b42eeb08fb89e0b"
SRC_URI[sha256sum] = "d40e2f1fd3f4bff386d27bbdf4b8645199b1995d27605a886b8c71e44d819591"

PACKAGES="${PN}"

do_fetch() {
    for package in "${SRC_URI}";
    do
        wget $package
        cp `basename $package` ${WORKDIR}
    done
}

do_unpack() {
    tar xvf ${WORKDIR}/${PN}-${PV}.tar.bz2
}

do_install() {
    install -m 644 -d ${D}${sbindir}
    install -m 755 ${S}/ddclient ${D}${sbindir}
}
