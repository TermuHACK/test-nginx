FROM nginx:alpine

# Установка пакетов
RUN apk update && apk add curl tinyproxy nano sudo ttyd bash

# Копируем конфиг nginx
COPY default.conf /etc/nginx/conf.d/default.conf

# Копируем entrypoint.sh
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
COPY tinyproxy.conf /etc/tinyproxy/tinyproxy.conf
RUN wget https://github.com/yudai/gotty/releases/download/v1.0.1/gotty_linux_amd64.tar.gz -O /tmp/gotty.tar.gz
RUN tar xvf /tmp/gotty.tar.gz && cp /tmp/gotty /usr/local/bin

# Указываем ENTRYPOINT
ENTRYPOINT ["/entrypoint.sh"]
