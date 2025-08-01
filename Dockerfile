FROM alpine:3.20

RUN apk update && apk add --no-cache \
    nginx curl bash libc6-compat ttyd unzip \
    && mkdir -p /run/nginx

# Установка Xray
RUN curl -L -o /tmp/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/xray-linux-64.zip && \
    unzip /tmp/xray.zip -d /tmp && \
    mv /tmp/xray /usr/local/bin/xray && \
    chmod +x /usr/local/bin/xray && \
    rm /tmp/xray.zip

# Каталоги
RUN mkdir -p /etc/xray /var/www/html

# Xray config
COPY <<EOF /etc/xray/config.json
{
  "inbounds": [
    {
      "port": 10000,
      "listen": "127.0.0.1",
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "550e8400-e29b-41d4-a716-446655440000",
            "level": 0
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": { "path": "/vpn" }
      }
    }
  ],
  "outbounds": [ { "protocol": "freedom" } ]
}
EOF

# NGINX config
COPY <<EOF /etc/nginx/conf.d/default.conf
server {
    listen $PORT;
    server_name localhost;

    location /vpn {
        proxy_redirect off;
        proxy_pass http://127.0.0.1:10000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
    }

    location /term/ {
        proxy_pass http://127.0.0.1:7681/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }

    location / {
        root /var/www/html;
        index index.html;
    }
}
EOF

# HTML
COPY <<EOF /var/www/html/index.html
<!DOCTYPE html>
<html><body><h1>VPN из говна и палок работает!</h1></body></html>
EOF

# Старт
COPY <<EOF /start.sh
#!/bin/bash
xray run -c /etc/xray/config.json &
ttyd -W -p 7681 bash &
nginx -g "daemon off;"
EOF

RUN chmod +x /start.sh

ENV PORT=8080
CMD ["/start.sh"]
