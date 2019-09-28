inherit autotools

SUMMARY = "Google Authenticator"
PV="1.2"
PR="r0"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

# Source code is in non-standard directory
S="${WORKDIR}/google-authenticator-1.02/libpam"

SRC_URI="https://github.com/google/google-authenticator/archive/1.02.tar.gz"


SRC_URI[md5sum] = "0976916600db2c9db5a48ede68543aad"
SRC_URI[sha256sum] = "638ff91c09f2e6acf10c5a3e0aaac0643112d123e33bef6d0d09669b868aba65"


# DEPENDS should not be package specific. RDEPENDS instead must be
RDEPENDS_${PN}+="libpam"
DEPENDS+="libpam"

EXTRA_OEMAKE = 'all -C ${S} CC="${CC}"'

# Do not split packages into bin/dbg, etc. Generate only one package.
PACKAGES = "${PN}"

# Disable the extraction of debug symbols. The generation of the -dbg package
# is already disabled with the PACKAGES directive above.
INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
FILES_${PN}="${libdir}/pam_google_authenticator.so ${bindir}/google-authenticator"

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
}
