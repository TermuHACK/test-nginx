FROM alpine:latest

RUN apk update && apk add --no-cache \
    curl bash nginx

# Скачиваем готовый gotty
RUN curl -Lo /usr/local/bin/gotty https://github.com/yudai/gotty/releases/download/v0.0.14/gotty_linux_amd64 && \
    chmod +x /usr/local/bin/gotty

COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80
CMD ["/entrypoint.sh"]
