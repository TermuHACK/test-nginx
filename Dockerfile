FROM alpine:3.20

# Установка зависимостей
RUN apk update && apk add --no-cache \
    nginx curl openssl bash libc6-compat ttyd unzip \
    && mkdir -p /run/nginx

# Установка Xray
RUN curl -L -o /tmp/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/xray-linux-64.zip && \
    unzip /tmp/xray.zip -d /tmp && \
    mv /tmp/xray /usr/local/bin/xray && \
    chmod +x /usr/local/bin/xray && \
    rm /tmp/xray.zip

# Создание каталогов
RUN mkdir -p /etc/xray /etc/ssl/certs /etc/ssl/private /var/www/html

# Фейковый SSL
RUN openssl req -x509 -nodes -newkey rsa:2048 -days 365 \
    -keyout /etc/ssl/private/privkey.pem \
    -out /etc/ssl/certs/fullchain.pem \
    -subj "/C=CN/ST=Denial/L=Nowhere/O=Dis/CN=localhost"

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
    listen $PORT ssl http2;
    server_name localhost;

    ssl_certificate     /etc/ssl/certs/fullchain.pem;
    ssl_certificate_key /etc/ssl/private/privkey.pem;

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

# Простая HTML-страница
COPY <<EOF /var/www/html/index.html
<!DOCTYPE html>
<html><body><h1>Welcome to Nginx!</h1></body></html>
EOF

# Скрипт запуска
COPY <<EOF /start.sh
#!/bin/bash
xray run -c /etc/xray/config.json &
ttyd -p 7681 bash &
nginx -g "daemon off;"
EOF

RUN chmod +x /start.sh

# Установка порта по умолчанию
ENV PORT=443

CMD ["/start.sh"]
