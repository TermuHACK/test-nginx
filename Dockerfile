FROM alpine:latest

# Установка зависимостей
RUN apk add --no-cache \
    python3 py3-pip \
    iproute2 iptables curl bash

# Установка Shadowsocks
RUN pip install https://github.com/shadowsocks/shadowsocks/archive/master.zip

# Установка gotty
RUN curl -Lo /usr/local/bin/gotty https://github.com/yudai/gotty/releases/latest/download/gotty_linux_amd64 \
    && chmod +x /usr/local/bin/gotty

# Рабочая папка
WORKDIR /app
COPY entrypoint.sh /entrypoint.sh
COPY config.json /etc/shadowsocks/config.json
RUN chmod +x /entrypoint.sh

# Порты для Render
EXPOSE 8388
EXPOSE 4200

ENV PORT=4200
ENTRYPOINT ["/entrypoint.sh"]
