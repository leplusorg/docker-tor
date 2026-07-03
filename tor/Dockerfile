FROM alpine:3.24.1@sha256:28bd5fe8b56d1bd048e5babf5b10710ebe0bae67db86916198a6eec434943f8b

SHELL ["/bin/ash", "-euo", "pipefail", "-c"]

HEALTHCHECK CMD ["/usr/bin/curl", "-fsSL", "--socks5", "localhost:9050", "--socks5-hostname", "localhost:9050", "https://check.torproject.org/api/ip"]

RUN apk upgrade --no-cache \
    && apk add --no-cache \
    bash=5.3.9-r1 \
    curl=8.20.0-r1 \
    gettext=1.0-r0 \
    git=2.54.0-r0 \
    tor=0.4.9.11-r0 \
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
