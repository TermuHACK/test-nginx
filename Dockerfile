FROM alpine
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
RUN apk update
RUN apk add \
    shadowsocks-libev \
    socat \
    git \
    bash \
    v2ray-plugin \
    curl \
    go \
    unzip \
    && rm -rf /var/cache/apk/*

RUN mkdir -p /shadowsocks && mkdir -p /xray
RUN curl -L -o v2ray-plugin.tar.gz https://github.com/shadowsocks/v2ray-plugin/releases/download/v1.3.2/v2ray-plugin-linux-amd64-v1.3.2.tar.gz \
    && tar -xzf v2ray-plugin.tar.gz -C /usr/local/bin \
    && mv /usr/local/bin/v2ray-plugin_linux_amd64 /usr/local/bin/v2ray-plugin \
    && rm v2ray-plugin.tar.gz

COPY entrypoint.sh /entrypoint.sh
COPY config.json /shadowsocks/config.json
COPY config1.json /xray/config.json

EXPOSE 8388 8080

RUN chmod +x /entrypoint.sh
RUN wget -O xray.zip https://github.com/XTLS/Xray-core/releases/download/v25.6.8/Xray-linux-64.zip && unzip xray.zip -d /xray
RUN chmod +x /xray/xray && cp /xray/xray /usr/local/bin/

ENTRYPOINT ["/entrypoint.sh"]
