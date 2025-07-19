#!/bin/sh

# Показать неофетчn#
#neofetch || true

# Запуск nginx
gotty --permit-write --once=false --reconnect -p 8080 bash
nginx

# Ожидание запуска
sleep 2

tinyproxy
# Чтобы контейнер не завершился
tail -f /dev/null
