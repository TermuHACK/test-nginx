FROM alpine:latest

RUN apk update && apk add --no-cache \
    curl go git bash nginx

# Устанавливаем gotty вручную
RUN git clone https://github.com/yudai/gotty.git /tmp/gotty && \
    cd /tmp/gotty && \
    go build -o /usr/local/bin/gotty && \
    chmod +x /usr/local/bin/gotty && \
    rm -rf /tmp/gotty

COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80
CMD ["/entrypoint.sh"]
