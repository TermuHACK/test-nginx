FROM debian:stable-slim

USER root
RUN apt update && apt install -y dante-server

COPY danted.conf /etc/danted.conf

EXPOSE 1080

CMD ["danted", "-f", "/etc/danted.conf"]
