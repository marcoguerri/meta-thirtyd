inherit autotools

SUMMARY = "Google Authenticator"
PV="1.2"
PR="r0"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

# Source code is in non-standard directory
S="${WORKDIR}/google-authenticator-1.02/libpam"

SRC_URI="https://github.com/google/google-authenticator/archive/1.02.tar.gz \
         file://.google_authenticator"


SRC_URI[md5sum] = "0976916600db2c9db5a48ede68543aad"
SRC_URI[sha256sum] = "638ff91c09f2e6acf10c5a3e0aaac0643112d123e33bef6d0d09669b868aba65"


RDEPENDS_${PN}="libpam"
DEPENDS_${PN}="libpam-dev"

EXTRA_OEMAKE = 'all -C ${S} CC="${CC}"'

# Explicitly tell which files to package
PACKAGES="${PN}"

FILES_${PN}="${libdir}/* ${bindir}/* /home/root/.google_authenticator"


do_configure_prepend() {
    
    chmod u+x ${S}/bootstrap.sh
    cd ${S}
    ./bootstrap.sh

}

do_compile() {
    oe_runmake
}

do_install() {

    install -m 0644 -d ${D}${libdir}
    install -m 0644 -d ${D}${bindir}

    cp ${S}/.libs/pam_google_authenticator.so ${D}${libdir}
    chmod 755 ${D}${libdir}/pam_google_authenticator.so
    
    cp ${S}/google-authenticator ${D}${bindir}
    chmod  755 ${D}${bindir}/google-authenticator

    install -m 0644 -d ${D}/home/root
    install -m 600 ${WORKDIR}/.google_authenticator ${D}/home/root

}
