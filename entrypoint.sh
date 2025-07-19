#!/bin/sh

# Показать неофетчn#
#neofetch || true

# Запуск nginx
ttyd -p 8080 bash -i
nginx

# Ожидание запуска
sleep 2

tinyproxy
# Чтобы контейнер не завершился
tail -f /dev/null
