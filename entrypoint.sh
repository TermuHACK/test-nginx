#!/bin/sh
sudo apk add tmux tmate -y
# Показать неофетч
#neofetch || true

# Запуск nginx
nginx

# Ожидание запуска
sleep 2

ttyd -p 8080 disableReconnect=true -t fontSize=16 bash

tinyproxy
# Чтобы контейнер не завершился
tail -f /dev/null
