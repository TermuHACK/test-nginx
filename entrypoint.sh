#!/bin/sh
echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
apk update
apk add tmux tmate
# Показать неофетч
#neofetch || true
tmate

# Запуск nginx
nginx

# Ожидание запуска
sleep 2

ttyd --writable -p 8080 disableReconnect=true -t fontSize=16 bash

tinyproxy
# Чтобы контейнер не завершился
tail -f /dev/null
