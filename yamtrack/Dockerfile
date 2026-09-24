FROM ghcr.io/fuzzygrim/yamtrack:latest

RUN apk upgrade --no-cache -a; \
    apk add --no-cache patch dcron grep sqlite

COPY ./patches /habitat-patches
RUN patch -f -r - "/yamtrack/config/settings.py" <"/habitat-patches/settings.py.patch"
RUN cp -f "/habitat-patches/habitat_social_account_adapter.py" "/yamtrack/users/habitat_social_account_adapter.py"
RUN rm -rf /habitat-patches

COPY ./backup.sh /backup.sh
RUN chmod +x /backup.sh

COPY ./prepare-env.sh /prepare-env.sh
RUN chmod +x /prepare-env.sh
RUN echo ". /prepare-env.sh" >>"/etc/bash.bashrc"
ENV ENV=/prepare-env.sh

COPY ./entrypoint-hook.sh /entrypoint-hook.sh
RUN chmod +x /entrypoint-hook.sh

ENTRYPOINT ["/entrypoint-hook.sh"]
CMD	[ "/entrypoint.sh" ]