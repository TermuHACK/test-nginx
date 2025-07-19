#!/bin/sh

# Показать неофетчn#
#neofetch || true

# Запуск nginx
sudo gotty -p 8080 --permit-write bash
nginx

# Ожидание запуска
sleep 2

tinyproxy
# Чтобы контейнер не завершился
tail -f /dev/null
