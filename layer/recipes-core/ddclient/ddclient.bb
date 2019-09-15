SUMMARY = "DynDns client"

LICENSE = "GPL-3.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-3.0;md5=c79ff39f19dfec6d293b95dea7b07891"

PV="3.8.3"
PR="r0"

RDEPENDS_${PN}="\
    perl \
    perl-module-strict \
    perl-module-getopt-long \
    perl-module-vars \
    perl-module-warnings-register \
    perl-module-warnings \
    perl-module-carp \
    perl-module-exporter \
    perl-module-constant \
    perl-module-exporter-heavy \
    perl-module-sys-hostname \
    perl-module-xsloader \
    perl-module-autoloader \
    perl-module-io-socket \
    perl-module-io-handle \
    perl-module-symbol \
    perl-module-selectsaver \
    perl-module-io \
    perl-module-socket \
    perl-module-errno \
    perl-module-config \
    perl-module-io-socket-inet \
    perl-module-io-socket-unix \
    perl-module-integer \
    perl-module-overloading"

S="${WORKDIR}/ddclient-${PV}"

SRC_URI="http://netcologne.dl.sourceforge.net/project/ddclient/ddclient/ddclient-${PV}.tar.bz2 \
         file://ddclient.conf"

SRC_URI[md5sum] = "3b426ae52d509e463b42eeb08fb89e0b"
SRC_URI[sha256sum] = "d40e2f1fd3f4bff386d27bbdf4b8645199b1995d27605a886b8c71e44d819591"

PACKAGES="${PN}"

FILES_${PN}="\
    ${sysconfdir}/ddclient/* \
    ${sbindir}/ddclient"

do_fetch() {
    for package in $(echo "${SRC_URI}" | sed 's/file:\/\/[^ \]*//g');
    do
        wget $package
        cp $(basename $package) ${WORKDIR}
    done

    for file in $(echo "${SRC_URI}" | sed 's/http[s\]\?:\/\/[^ \]*//g');
    do
        cp ${FILE_DIRNAME}/files/$(echo $file | sed 's/file:\/\///') ${WORKDIR}
    done
}

do_unpack() {
    tar xvf ${WORKDIR}/${PN}-${PV}.tar.bz2
}

do_install() {
    install -m 644 -d ${D}${sbindir}
    install -m 755 ${S}/ddclient ${D}${sbindir}
    install -m 644 -d ${D}${sysconfdir}/ddclient
    install -m 755 ${WORKDIR}/ddclient.conf ${D}${sysconfdir}/ddclient
}
