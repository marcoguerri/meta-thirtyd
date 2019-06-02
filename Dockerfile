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
		texinfo \
		vim \
		wget

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

RUN useradd -m dev

USER dev

RUN cd $HOME && \
	mkdir openembedded && cd openembedded && \
	git clone -b sumo https://github.com/openembedded/openembedded-core.git && \
	install -d openembedded-core/build/conf && \
	git clone -b 1.38 git://git.openembedded.org/bitbake.git && \
	git clone -b sumo git://github.com/openembedded/meta-openembedded.git && \
	git clone -b sumo https://github.com/agherzan/meta-raspberrypi && \
	git clone https://github.com/marcoguerri/meta-thirtyd


ARG oe_home=/home/dev
COPY local.conf $oe_home/openembedded/openembedded-core/build/conf/local.conf
COPY bblayers.conf $oe_home/openembedded/openembedded-core/build/conf/bblayers.conf

RUN virtualenv -p /usr/bin/python2.7 $HOME/p27
