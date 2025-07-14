FROM alpine:latest

RUN apk update && apk add --no-cache \
    curl tar bash file nginx

# Качаем и ставим gotty (v1.0.1), сразу в нужное место
RUN curl -sSL -o /tmp/gotty.tar.gz https://github.com/yudai/gotty/releases/download/v1.0.1/gotty_linux_amd64.tar.gz && \
    tar -xzf /tmp/gotty.tar.gz -C /usr/local/bin && \
    chmod +x /usr/local/bin/gotty && \
    file /usr/local/bin/gotty && \
    rm -rf /tmp/gotty.tar.gz

COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80
CMD ["/entrypoint.sh"]
