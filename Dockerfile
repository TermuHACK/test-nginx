FROM alpine
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
RUN apk update
RUN apk add \
    shadowsocks-libev \
    socat \
    git \
    bash \
    curl \
    go \
    unzip \
    autoconf \
    automake \
    build-base \
    c-ares-dev \
    libcap \
    libev-dev \
    libtool \
    libsodium-dev \
    linux-headers \
    mbedtls-dev \
    pcre-dev \
    && rm -rf /var/cache/apk/*

RUN mkdir -p /shadowsocks && mkdir -p /xray
RUN curl -L -o v2ray-plugin.tar.gz https://github.com/shadowsocks/v2ray-plugin/releases/download/v1.3.2/v2ray-plugin-linux-amd64-v1.3.2.tar.gz \
    && tar -xzf v2ray-plugin.tar.gz -C /usr/local/bin \
    && mv /usr/local/bin/v2ray-plugin_linux_amd64 /usr/local/bin/v2ray-plugin \
    && rm v2ray-plugin.tar.gz

RUN wget -O /tmp/ss.tar.gz https://github.com/shadowsocks/shadowsocks-libev/releases/download/v3.3.5/shadowsocks-libev-3.3.5.tar.gz && \
 && cd /tmp/ \
 && ./autogen.sh \
 && ./configure --prefix=/usr --disable-documentation \
 && make install \
 && ls /usr/bin/ss-* | xargs -n1 setcap cap_net_bind_service+ep \
 && apk add --no-cache \
      ca-certificates \
      rng-tools \
      tzdata \
      $(scanelf --needed --nobanner /usr/bin/ss-* \
      | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
      | sort -u) \
 && rm -rf /tmp/*



COPY entrypoint.sh /entrypoint.sh
COPY config.json /shadowsocks/config.json
COPY config1.json /xray/config.json

EXPOSE 8388 8080

RUN chmod +x /entrypoint.sh
RUN wget -O xray.zip https://github.com/XTLS/Xray-core/releases/download/v25.6.8/Xray-linux-64.zip && unzip xray.zip -d /xray
RUN chmod +x /xray/xray && cp /xray/xray /usr/local/bin/

ENTRYPOINT ["/entrypoint.sh"]
