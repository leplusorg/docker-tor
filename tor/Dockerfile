FROM alpine:3.21.2@sha256:56fa17d2a7e7f168a043a2712e63aed1f8543aeafdcee47c58dcffe38ed51099

HEALTHCHECK CMD ["/usr/bin/curl", "--socks5", "localhost:9050", "--socks5-hostname", "localhost:9050", "https://check.torproject.org/api/ip"]

# hadolint ignore=DL3018
RUN apk --update --no-cache add bash curl gettext tor \
    && rm -rf /var/cache/apk/* \
    && chmod o+rwx /etc/tor

USER "tor"

COPY torrc.template tor-wrapper.sh /etc/tor/

WORKDIR "/var/lib/tor"

EXPOSE 9050

CMD ["/etc/tor/tor-wrapper.sh"]
ENTRYPOINT []
