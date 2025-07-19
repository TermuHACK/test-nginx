#!/bin/sh

# Показать неофетчn#
#neofetch || true

# Запуск nginx
nginx

# Ожидание запуска
sleep 2

# Запуск SSHX.io (или другого скрипта)
curl -sSf https://sshx.io/get | sh
/usr/local/bin/sshx

# Чтобы контейнер не завершился
tail -f /dev/null
