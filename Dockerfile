FROM alpine
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
RUN apk add --update \
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
RUN git clone https://github.com/shadowsocks/v2ray-plugin.git && cd v2ray-plugin && go build
WORKDIR /

COPY entrypoint.sh /entrypoint.sh
COPY config.json /shadowsocks/config.json
COPY config1.json /xray/config.json

EXPOSE 8388 8080

RUN chmod +x /entrypoint.sh
RUN wget -O xray.zip https://github.com/XTLS/Xray-core/releases/download/v25.6.8/Xray-linux-64.zip && unzip xray.zip -d /xray
RUN chmod +x /xray/xray && cp /xray/xray /usr/local/bin/

ENTRYPOINT ["/entrypoint.sh"]
