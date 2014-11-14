#!/bin/bash

exec 2>&1
set -e
set -x

ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime

apt-get update
apt-get install -y --force-yes \
    apache2 \
    aspell-en \
    autoconf \
    bind9-host \
    bison \
    build-essential \
    coreutils \
    cracklib-runtime \
    curl \
    daemontools \
    dnsutils \
    ed \
    git \
    imagemagick \
    iputils-tracepath \
    language-pack-en \
    libbz2-dev \
    libcurl4-openssl-dev \
    libevent-dev \
    libglib2.0-dev \
    libjpeg-dev \
    libmagickwand-dev \
    libmysqlclient-dev \
    libncurses5-dev \
    libpq-dev \
    libpq5 \
    libreadline6-dev \
    libssl-dev \
    libxml2-dev \
    libxslt-dev \
    netcat-openbsd \
    nodejs \
    npm \
    openssh-client \
    openssh-server \
    php5 \
    php5-common \
    php5-cli \
    php5-dev \
    php-pear \
    php5-imap \
    php5-mysqlnd \
    php5-pspell \
    php5-json \
    php5-curl \
    php5-xsl \
    postfix \
    python \
    python-dev \
    ruby \
    ruby-dev \
    socat \
    syslinux \
    sysstat \
    tar \
    telnet \
    wamerican \
    wget \
    zip \
    zlib1g-dev \
    #

# New Relic
echo deb http://apt.newrelic.com/debian/ newrelic non-free >> /etc/apt/sources.list.d/newrelic.list
wget -O- https://download.newrelic.com/548C16BF.gpg | apt-key add -
apt-get update
apt-get install -y --force-yes newrelic-sysmond newrelic-php5

npm install coffee-script -g
ln -s /usr/bin/nodejs /usr/bin/node

a2enmod ssl expires rewrite headers proxy proxy_http remoteip
# TODO address logging in general
# a2enconf _jsonlog

cd /
rm -rf /var/cache/apt/archives/*.deb
rm -rf /root/*
rm -rf /tmp/*

# remove SUID and SGID flags from all binaries
function pruned_find() {
  find / -type d \( -name dev -o -name proc \) -prune -o $@ -print
}

pruned_find -perm /u+s | xargs -r chmod u-s
pruned_find -perm /g+s | xargs -r chmod g-s

# remove non-root ownership of files
chown root:root /var/lib/libuuid

# display build summary
set +x
echo -e "\nRemaining suspicious security bits:"
(
  pruned_find ! -user root
  pruned_find -perm /u+s
  pruned_find -perm /g+s
  pruned_find -perm /+t
) | sed -u "s/^/  /"

echo -e "\nInstalled versions:"
(
  git --version
  ruby -v
  gem -v
  python -V
) | sed -u "s/^/  /"

echo -e "\nSuccess!"
exit 0
