#!/bin/sh
echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
apk update


# Запуск nginx
nginx

# Ожидание запуска
sleep 2
tinyproxy -d -p 8080 -a 127.0.0.1
# Чтобы контейнер не завершился
tail -f /dev/null
