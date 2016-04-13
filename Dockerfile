##################################################
# Dockerfile for the BBB Toolchain
##################################################
FROM debian:jessie
MAINTAINER Alejandro Schwoykoski alejandro@siana-systems.com

# 1. Install basic development packages
# 2. Add armhf as new architecture
# 3. Install crosstools for armhf
RUN apt-get update -q && \
DEBIAN_FRONTEND=noninteractive apt-get install -y -q \
automake \
binutils \
cmake \
curl \
gawk \
git \
nano \
lib32stdc++6 \
lib32z1 \
libtool \
runit

RUN echo 'deb http://emdebian.org/tools/debian jessie main' > /etc/apt/sources.list.d/crosstools.list && \
curl http://emdebian.org/tools/debian/emdebian-toolchain-archive.key | apt-key add - && \
dpkg --add-architecture armhf && \
apt-get update -q && \
DEBIAN_FRONTEND=noninteractive apt-get install -y -q \
crossbuild-essential-armhf && \
apt-get -q -y clean && \
cd /usr/bin && \
ln -s arm-linux-gnueabihf-cpp-* arm-linux-gnueabihf-cpp
# may have to fix previous link provided cpp-4.9 is other version...

# Hardcode of toolchain
ENV HOST=arm-linux-gnueabihf \
    CROSS_ROOT_BINDIR=/usr/bin

ENV ARCH=arm \
    CROSS_COMPILE=${CROSS_ROOT_BINDIR}/${HOST}- \
    ARM_CROSS_COMPILER=TRUE

ENV AS=${CROSS_COMPILE}as \
    AR=${CROSS_COMPILE}ar \
    CC=${CROSS_COMPILE}gcc \
    CPP=${CROSS_COMPILE}cpp \
    CXX=${CROSS_COMPILE}g++ \
    LD=${CROSS_COMPILE}ld

#finish
WORKDIR /build
ENTRYPOINT ["/bbbxc/entrypoint.sh"]

COPY imagefiles/entrypoint.sh imagefiles/bbbxc /bbbxc/

# End Dockerfile
