#!/bin/sh

echo "🖥️ Запускаем gotty на 127.0.0.1:9000"
/usr/local/bin/gotty --port 9000 --permit-write --title-format "🛠 Web Shell" bash &

echo "🌐 Запускаем nginx на 0.0.0.0:80"
nginx -g "daemon off;"
