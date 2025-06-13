FROM alpine
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk update
RUN apk add \
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
    shadowsocks-libev \
    && rm -rf /var/cache/apk/*

RUN mkdir -p /shadowsocks && mkdir -p /xray

# Install xray
RUN curl -L -o xray.zip https://github.com/XTLS/Xray-core/releases/download/v1.8.24/Xray-linux-64.zip && \
    unzip Xray-linux-64.zip -d /xray && \
    mv /xray/xray /usr/local/bin/ && \
    chmod +x /usr/local/bin/xray && \
    rm Xray-linux-64.zip

COPY entrypoint.sh /entrypoint.sh
COPY config.json /shadowsocks/config.json
COPY config1.json /xray/config.json

EXPOSE 8388
EXPOSE 9999
EXPOSE 8080

RUN chmod +x /entrypoint.sh
RUN wget -O xray.zip https://github.com/XTLS/Xray-core/releases/download/v25.6.8/Xray-linux-64.zip && unzip xray.zip -d /xray
RUN chmod +x /xray/xray && cp /xray/xray /usr/local/bin/

ENTRYPOINT ["/entrypoint.sh"]
