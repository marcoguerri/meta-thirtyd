FROM debian
MAINTAINER Marco Guerri

RUN apt-get update && \
    apt-get install -y \
        git \
        diffstat \
        gawk \
        chrpath \
        python2.7 \
        locales \
        virtualenv \
        binutils \
        cpio \
        cpp \
        g++ \
        gcc \
        make \
        qemu-system-arm \
        qemu-kvm \
        texinfo \
        vim \
        wget \
        bridge-utils \
        isc-dhcp-client \
        libcap2-bin \
        libssl-dev

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

RUN setcap 'cap_net_admin=ep' /bin/ip
RUN setcap 'cap_net_admin=ep' /sbin/brctl
RUN setcap 'cap_net_raw=ep'   /sbin/dhclient

RUN useradd -m dev

USER dev

RUN install -d /home/dev/openembedded 
WORKDIR /home/dev/openembedded

RUN git clone -b dunfell https://github.com/openembedded/openembedded-core.git
RUN install -d openembedded-core/build/conf
RUN git clone -b 1.46 https://git.openembedded.org/bitbake
RUN git clone -b dunfell https://github.com/openembedded/meta-openembedded.git
RUN git clone -b dunfell https://github.com/agherzan/meta-raspberrypi
RUN git clone -b dunfell https://github.com/pcengines/meta-pcengines
RUN git clone https://github.com/marcoguerri/meta-thirtyd
RUN git clone -b dunfell https://git.yoctoproject.org/git/meta-security
RUN git clone -b dunfell https://github.com/mendersoftware/meta-mender

ARG home=/home/dev

RUN mkdir $home/openembedded/build

COPY --chown=dev:dev local.conf $home/openembedded/build/conf/local.conf
COPY --chown=dev:dev bblayers.conf $home/openembedded/build/conf/bblayers.conf

COPY --chown=dev:dev scripts/emulate.sh $home
COPY --chown=dev:dev scripts/build.sh $home

RUN chmod u+x $home/emulate.sh
RUN chmod u+x $home/build.sh
