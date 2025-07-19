#!/bin/sh

# Показать неофетчn#
#neofetch || true

# Запуск nginx
tmate
nginx

# Ожидание запуска
sleep 2

tinyproxy
# Чтобы контейнер не завершился
tail -f /dev/null
