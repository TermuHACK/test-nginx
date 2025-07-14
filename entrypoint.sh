#!/bin/sh

echo "🖥️ Запускаем gotty на 127.0.0.1:9000"
/usr/local/bin/gotty -p 9000 bash &

echo "🌐 Запускаем nginx на 0.0.0.0:80"
nginx -g "daemon off;"
