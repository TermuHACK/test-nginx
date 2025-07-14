FROM alpine:latest

RUN apk update && apk add --no-cache \
    curl tar bash nginx openssh

# Ставим tmate (статичный бинарник)
RUN curl -Lo /usr/local/bin/tmate https://github.com/tmate-io/tmate/releases/download/2.4.0/tmate-2.4.0-static-linux-amd64.tar.xz && \
    tar -xf /usr/local/bin/tmate && \
    mv tmate /usr/local/bin/tmate && \
    chmod +x /usr/local/bin/tmate && \
    rm -f tmate-2.4.0-static-linux-amd64.tar.xz

COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80
CMD ["/entrypoint.sh"]
