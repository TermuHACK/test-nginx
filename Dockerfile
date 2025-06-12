FROM alpine:3.18

# Установка зависимостей
RUN apk add --no-cache \
    bash curl wget tar unzip git \
    shadowsocks-libev \
    libev-dev c-ares-dev libsodium-dev mbedtls-dev \
    gotty

# Установка gotty вручную (если в apk нет нужной версии)
RUN wget https://github.com/yudai/gotty/releases/download/v1.0.1/gotty_linux_amd64.tar.gz && \
    tar -xzf gotty_linux_amd64.tar.gz && \
    mv gotty /usr/local/bin/ && \
    rm gotty_linux_amd64.tar.gz

# Копируем скрипт запуска
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8388 7681

ENTRYPOINT ["/entrypoint.sh"]
