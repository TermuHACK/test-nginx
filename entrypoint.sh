#!/bin/sh

# Показать неофетч
#neofetch || true

# Запуск nginx
nginx

# Ожидание запуска
sleep 2

tinyproxy
# Чтобы контейнер не завершился
tail -f /dev/null
