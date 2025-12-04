FROM alpine:3.23.0@sha256:51183f2cfa6320055da30872f211093f9ff1d3cf06f39a0bdb212314c5dc7375

SHELL ["/bin/ash", "-euo", "pipefail", "-c"]

HEALTHCHECK CMD ["/usr/bin/curl", "-fsSL", "--socks5", "localhost:9050", "--socks5-hostname", "localhost:9050", "https://check.torproject.org/api/ip"]

RUN apk upgrade --no-cache \
    && apk add --no-cache \
    bash=5.2.37-r0 \
    curl=8.14.1-r2 \
    gettext=0.24.1-r0 \
    git=2.49.1-r0 \
    tor=0.4.8.21-r0 \
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
