FROM alpine:latest

RUN apk update && apk add --no-cache \
    curl go bash nginx

# Устанавливаем gotty
RUN go install github.com/yudai/gotty@latest && \
    cp /root/go/bin/gotty /usr/local/bin && chmod +x /usr/local/bin/gotty

COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80
CMD ["/entrypoint.sh"]
