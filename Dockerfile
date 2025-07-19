FROM nginx:alpine

# Установка пакетов
RUN apk update && apk add --no-cache neofetch curl tinyproxy nano sudo bash

# Копируем конфиг nginx
COPY default.conf /etc/nginx/conf.d/default.conf

# Копируем entrypoint.sh
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Указываем ENTRYPOINT
ENTRYPOINT ["/entrypoint.sh"]
