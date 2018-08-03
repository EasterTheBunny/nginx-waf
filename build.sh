#!/bin/sh

apt-get update
apt-get install -y apt-utils automake git wget build-essential libpcre3 libpcre3-dev libssl-dev libtool autoconf apache2-dev libxml2-dev libcurl4-openssl-dev zlib1g


# make modsecurity
cd /usr/src/
git clone --depth 1 -b v3/master --single-branch https://github.com/SpiderLabs/ModSecurity /usr/src/modsecurity
cd /usr/src/modsecurity
git submodule init
git submodule update
./build.sh
./configure
make
make install

rm -rf /usr/src/modsecurity

# download nginx modsecurity module source
cd /usr/src
git clone --depth 1 https://github.com/SpiderLabs/ModSecurity-nginx.git

# make nginx module using module source
cd /usr/src
wget https://nginx.org/download/nginx-1.15.2.tar.gz
tar xvzf nginx-1.15.2.tar.gz

cd /usr/src/nginx-1.15.2
./configure --with-compat --add-dynamic-module=../ModSecurity-nginx --without-http_gzip_module
make modules

cp objs/ngx_http_modsecurity_module.so /etc/nginx/modules

# get core rules
git clone https://github.com/SpiderLabs/owasp-modsecurity-crs.git /usr/src/owasp-modsecurity-crs
mkdir /etc/nginx/conf
cp -R /usr/src/owasp-modsecurity-crs/rules /etc/nginx/conf/
cp /usr/src/owasp-modsecurity-crs/crs-setup.conf.example /etc/nginx/conf/crs-setup.conf
mv /etc/nginx/conf/rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf{.example,}
mv /etc/nginx/conf/rules/RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf{.example,}

# clean up src
rm -rf /usr/src/*

# set initial recommended modsecurity conf
wget -P /etc/nginx/conf/ https://raw.githubusercontent.com/SpiderLabs/ModSecurity/v3/master/modsecurity.conf-recommended
mv /etc/nginx/conf/modsecurity.conf-recommended /etc/nginx/conf/modsecurity.conf

apt-get autoremove -y
