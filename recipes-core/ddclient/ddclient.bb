SUMMARY = "DynDns client"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

PV="3.8.3"
PR="r0"

RDEPENDS_${PN}+="perl"
RDEPENDS_${PN}+="perl-module-strict"
RDEPENDS_${PN}+="perl-module-getopt-long"
RDEPENDS_${PN}+="perl-module-vars"
RDEPENDS_${PN}+="perl-module-warnings-register"
RDEPENDS_${PN}+="perl-module-warnings"
RDEPENDS_${PN}+="perl-module-carp"
RDEPENDS_${PN}+="perl-module-exporter"
RDEPENDS_${PN}+="perl-module-constant"
RDEPENDS_${PN}+="perl-module-exporter-heavy"
RDEPENDS_${PN}+="perl-module-sys-hostname"
RDEPENDS_${PN}+="perl-module-xsloader"
RDEPENDS_${PN}+="perl-module-autoloader"
RDEPENDS_${PN}+="perl-module-io-socket"
RDEPENDS_${PN}+="perl-module-io-handle"
RDEPENDS_${PN}+="perl-module-symbol"
RDEPENDS_${PN}+="perl-module-selectsaver"
RDEPENDS_${PN}+="perl-module-io"
RDEPENDS_${PN}+="perl-module-socket"
RDEPENDS_${PN}+="perl-module-errno"
RDEPENDS_${PN}+="perl-module-config"
RDEPENDS_${PN}+="perl-module-io-socket-inet"
RDEPENDS_${PN}+="perl-module-io-socket-unix"
RDEPENDS_${PN}+="perl-module-integer"
RDEPENDS_${PN}+="perl-module-overload"

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
