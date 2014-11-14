FROM ubuntu-debootstrap:14.04
MAINTAINER dustMason "jordan@nuts.com"

ADD ./build.sh /tmp/build.sh
RUN LC_ALL=C DEBIAN_FRONTEND=noninteractive /tmp/build.sh
