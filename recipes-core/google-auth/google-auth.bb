inherit autotools

SUMMARY = "Google Authenticator"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

#
# Notes: apparently do_install is executed in WORKDIR and not in S.
# So an addition -C is necessary to change directory so S before invoking make install 
#
S="${WORKDIR}/libpam-google-authenticator-1.0"

SRC_URI="https://google-authenticator.googlecode.com/files/libpam-google-authenticator-1.0-source.tar.bz2 \
        file://.google_authenticator"


SRC_URI[md5sum] = "9db0194fcae26a67dcedbcd49397e95e"
SRC_URI[sha256sum] = "80426045d13ce7a2bf56c692ccfb1751cef3c7484752ad40738facf729264d4b"


RDEPENDS_${PN}="libpam"
DEPENDS_${PN}="libpam-dev"

EXTRA_OEMAKE = 'all -C ${S} CC="${CC}"'

# Explicitly tell which files to package
PACKAGES="${PN}"

FILES_${PN}="${libdir}/* ${bindir}/* .google_authenticator"

do_compile() {
    oe_runmake
}

do_install() {

    install -m 0644 -d ${D}${libdir}
    install -m 0644 -d ${D}${bindir}

    cp ${S}/pam_google_authenticator.so ${D}${libdir}
    chmod  755 ${D}${libdir}/pam_google_authenticator.so
    
    cp ${S}/google-authenticator ${D}${bindir}
    chmod  755 ${D}${bindir}/google-authenticator

    install -m 0644 ${WORKDIR}/.google_authenticator ${D}

}
