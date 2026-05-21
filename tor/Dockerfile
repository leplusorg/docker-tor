FROM alpine:3.23.4@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11

SHELL ["/bin/ash", "-euo", "pipefail", "-c"]

HEALTHCHECK CMD ["/usr/bin/curl", "-fsSL", "--socks5", "localhost:9050", "--socks5-hostname", "localhost:9050", "https://check.torproject.org/api/ip"]

RUN apk upgrade --no-cache \
    && apk add --no-cache \
    bash=5.3.3-r1 \
    curl=8.19.0-r0 \
    gettext=0.24.1-r1 \
    git=2.52.0-r0 \
    tor=0.4.9.8-r0 \
    && apk cache --no-cache clean \
    && rm -rf /var/cache/apk/*

RUN chmod ugo+rwx /etc/tor

COPY torrc.template tor-wrapper.sh /etc/tor/

RUN chmod ugo+rx /etc/tor/tor-wrapper.sh

USER "tor"

WORKDIR "/var/lib/tor"

EXPOSE 9050

ENTRYPOINT ["/etc/tor/tor-wrapper.sh"]

CMD []
