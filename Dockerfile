FROM nginx:alpine

# Установка пакетов
RUN apk update && apk add curl tinyproxy nano sudo ttyd bash

# Копируем конфиг nginx
COPY default.conf /etc/nginx/conf.d/default.conf

# Копируем entrypoint.sh
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
COPY tinyproxy.conf /etc/tinyproxy/tinyproxy.conf

# Указываем ENTRYPOINT
ENTRYPOINT ["/entrypoint.sh"]
