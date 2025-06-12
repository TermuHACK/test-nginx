FROM alpine:latest

# Установка зависимостей
RUN apk add --no-cache \
    python3 py3-pip \
    shellinabox \
    iptables iproute2 curl

# Установка Shadowsocks + плагина
RUN pip install https://github.com/shadowsocks/shadowsocks/archive/master.zip

# Папки
WORKDIR /app
COPY entrypoint.sh /entrypoint.sh
COPY config.json /etc/shadowsocks/config.json

RUN chmod +x /entrypoint.sh

# Указание портов для Render
EXPOSE 8388
EXPOSE 4200

ENV PORT=4200
ENTRYPOINT ["/entrypoint.sh"]
