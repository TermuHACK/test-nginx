#!/bin/sh

echo "🖥️ Запускаем tmate-сессию..."
tmate -F &
echo "🌐 Запускаем nginx..."
nginx -g "daemon off;"
