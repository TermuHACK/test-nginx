#!/bin/sh

UUID=$(cat /proc/sys/kernel/random/uuid)

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
        "path": "/"
      }
    }
  }],
  "outbounds": [{
    "protocol": "freedom"
  }]
}
EOF

echo "====================================="
echo "✅ Xray UUID: $UUID"
echo "🌐 WebSocket: wss://<render-url>/"
echo "🌀 TinyProxy: http://<render-url>:8888/"
echo "====================================="

tmux new-session -d -s services 'xray -c /etc/xray-config.json'
tmux split-window -v 'tinyproxy -d'
tmux split-window -h 'tmate -F'
tmux attach-session -t services
