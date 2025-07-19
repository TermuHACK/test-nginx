#!/bin/sh
echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
apk update


# Запуск nginx
nginx

# Ожидание запуска
sleep 2
echo -e "Port 8080\nListen 127.0.0.1\nConnectPort 443\nConnectPort 80" > /tmp/tinyproxy.conf && tinyproxy -d -c /tmp/tinyproxy.conf

# Чтобы контейнер не завершился
tail -f /dev/null
