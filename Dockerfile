# Заготовка Dockerfile
FROM alpine:latest

RUN apk update && apk add --no-cache curl tmux openssh tinyproxy bash xz unzip && \
  curl -L https://github.com/tmate-io/tmate/releases/download/2.4.0/tmate-2.4.0-static-linux-amd64.tar.xz \
  	  | tar -xJ && mv tmate-2.4.0-static-linux-amd64/tmate /usr/local/bin/tmate && \
  	  chmod +x /usr/local/bin/tmate && rm -rf tmate-2.4.0-static-linux-amd64* && \
  sed -i 's/^#Allow 127.0.0.1/Allow 0.0.0.0/' /etc/tinyproxy/tinyproxy.conf && \
  sed -i 's/^Allow 127.0.0.1/#Allow 127.0.0.1/' /etc/tinyproxy/tinyproxy.conf && \
  sed -i 's/^#LogLevel Info/LogLevel Error/' /etc/tinyproxy/tinyproxy.conf && \
  echo "MaxClients 100\nStartServers 1\nMinSpareServers 1\nMaxSpareServers 5" >> /etc/tinyproxy/tinyproxy.conf

# Установка Xray-core
RUN curl -L -o /tmp/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip && \
  unzip /tmp/xray.zip -d /usr/local/bin && chmod +x /usr/local/bin/xray && rm /tmp/xray.zip

# Генерация UUID и конфигов при запуске
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8888 10000
CMD ["/entrypoint.sh"]
