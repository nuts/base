FROM ubuntu-debootstrap:14.04
MAINTAINER dustMason "jordan@nuts.com"

# install deps
ADD ./build.sh /tmp/build.sh
RUN LC_ALL=C DEBIAN_FRONTEND=noninteractive /tmp/build.sh

# apache
ADD ./apache/jsonlog.conf /etc/apache2/conf-available/jsonlog.conf
RUN a2enmod ssl expires rewrite headers proxy proxy_http remoteip
RUN a2enconf jsonlog
RUN service apache2 restart
