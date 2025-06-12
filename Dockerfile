FROM alpine:latest

RUN apk add --no-cache \
    python3 py3-pip \
    iproute2 iptables curl bash

# Установка Shadowsocks с флагом --break-system-packages
RUN pip install --break-system-packages https://github.com/shadowsocks/shadowsocks/archive/master.zip

# Установка gotty
RUN curl -L https://github.com/yudai/gotty/releases/download/v1.0.1/gotty_linux_amd64.tar.gz | tar xz && \
    mv gotty /usr/local/bin/

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8388 8080

CMD ["/entrypoint.sh"]
