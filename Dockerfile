FROM alpine:3.18

COPY setup.sh /setup.sh
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /setup.sh /entrypoint.sh && /setup.sh

EXPOSE 8388 8080

ENTRYPOINT ["/entrypoint.sh"]
