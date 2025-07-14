#!/bin/sh

UUID=$(cat /proc/sys/kernel/random/uuid)

# Xray конфиг
cat > /etc/xray-config.json <<EOF
{
  "inbounds": [{
    "port": 10000,
    "protocol": "vless",
    "settings": {
      "clients": [{
        "id": "$UUID",
        "flow": ""
      }],
      "decryption": "none"
    },
    "streamSettings": {
      "network": "ws",
      "wsSettings": {
        "path": "/ws"
      }
    }
  }],
  "outbounds": [{
    "protocol": "freedom"
  }]
}
EOF

echo "🎯 UUID: $UUID"
echo "🔌 VLESS WS: /ws"
echo "🌐 Proxy: /proxy"
echo "🖥️ Tmate (через /)"

# запускаем всё в фоне
tmate -F &
tinyproxy -d &
xray -c /etc/xray-config.json &

# nginx в ФГ
nginx -g "daemon off;"
