#!/bin/sh
set -e

apk update && apk upgrade

apk add --no-cache \
    bash curl wget tar unzip git \
    libev-dev c-ares-dev libsodium-dev mbedtls-dev

wget -O /usr/local/bin/gotty https://github.com/yudai/gotty/releases/download/v0.2.0/gotty_linux_amd64
chmod +x /usr/local/bin/gotty

apk add --no-cache build-base autoconf libtool

git clone --depth=1 https://github.com/shadowsocks/shadowsocks-libev.git
cd shadowsocks-libev
git submodule update --init --recursive
./autogen.sh
./configure && make && make install
cd ..
rm -rf shadowsocks-libev

echo "[*] Готово!"
