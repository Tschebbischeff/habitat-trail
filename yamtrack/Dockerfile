FROM ghcr.io/fuzzygrim/yamtrack:latest

RUN apk upgrade --no-cache -a; \
    apk add --no-cache dcron grep sqlite

COPY ./backup.sh /backup.sh
RUN chmod +x /backup.sh

COPY ./entrypoint-hook.sh /entrypoint-hook.sh
RUN chmod +x /entrypoint-hook.sh

ENTRYPOINT ["/entrypoint-hook.sh"]
CMD	[ "/entrypoint.sh" ]