inherit module

SUMMARY = "Vendor driver for rtl8192 chipset"
PV="1.0"
PR="r0"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI="https://static.tp-link.com/2018/201805/20180514/TP-Link_Driver_Linux_series8_beta.zip; \
         file://kernel.patch;"

SRC_URI[md5sum] = "e2c4dbb26f2a4d3eaa6f52328b6e6010"
SRC_URI[sha256sum] = "f86f3f5af14ae8466b92582d6a36cb604e834e0447d85c2c03046956717f5393"

# Do not split packages into bin/dbg, etc. Generate only one package.
PACKAGES = "${PN}"

SRC_DIR="rtl8192EU_WiFi_linux_v5.2.19.1_25633.20171222_COEX20171113-0047"
B="${S}"

RPROVIDES_${PN}="kernel-module-8192eu-${KERNEL_VERSION}"

FILES_${PN}="${base_libdir}/modules/"

DEPENDS="bison-native bc-native openssl-native"

do_unpack() {
  # Unpack sources in ${WORKDIR} and make them available in ${S}
  unzip -o "${DL_DIR}/TP-Link_Driver_Linux_series8_beta.zip"
  unzip -o rtl8192EU_WiFi_linux_v5.2.19.1_25633.20171222_COEX20171113-0047.zip
  mv "${WORKDIR}"/rtl8192EU_WiFi_linux_v5.2.19.1_25633.20171222_COEX20171113-0047/* "${S}"
}


do_compile() {
  set -x
  # External kernel modules require include/generated/autoconf.h to be generated from .config
  sed -i 's/CONFIG_PLATFORM_I386_PC = y/CONFIG_PLATFORM_I386_PC = n/' Makefile
  sed -i 's/CONFIG_PLATFORM_BCM2709 = n/CONFIG_PLATFORM_BCM2709 = y/' Makefile

  sed -i 's|KVER  :=.*|KVER  := ${KERNEL_VERSION}|' Makefile
  sed -i 's|KSRC :=.*|KSRC := ${STAGING_KERNEL_DIR}|' Makefile

  make
}


do_install() {
  install -d "${D}${base_libdir}/modules/${KERNEL_VERSION}/kernel/drivers/net/wireless"
  cp 8192eu.ko "${D}${base_libdir}/modules/${KERNEL_VERSION}/kernel/drivers/net/wireless"
}
