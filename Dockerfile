FROM alpine:3.18

# Установка зависимостей
RUN apk add --no-cache \
    bash curl wget tar unzip git build-base openssl-dev libffi-dev \
    python3 py3-pip

# Установка shadowsocks из GitHub
RUN pip install https://github.com/shadowsocks/shadowsocks/archive/master.zip

# Установка gotty (веб-терминал)
RUN wget https://github.com/yudai/gotty/releases/download/v0.2.0/gotty_linux_amd64.tar.gz && \
    tar -xzf gotty_linux_amd64.tar.gz && \
    mv gotty /usr/local/bin/ && \
    rm gotty_linux_amd64.tar.gz

# Копируем скрипт запуска
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8388 7681

ENTRYPOINT ["/entrypoint.sh"]
