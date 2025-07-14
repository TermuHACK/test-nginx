FROM alpine:latest

# Устанавливаем зависимости
RUN apk update && apk add --no-cache \
    curl go git bash nginx sudo

# Создаём GOPATH и ставим gotty как root
RUN mkdir -p /root/go && \
    export GOPATH=/root/go && \
    go get github.com/yudai/gotty && \
    cp /root/go/bin/gotty /usr/local/bin/gotty && \
    chmod +x /usr/local/bin/gotty

# Копируем конфиги и стартовый скрипт
COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80
CMD ["/entrypoint.sh"]
