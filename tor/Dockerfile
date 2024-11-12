FROM alpine:3.20.3@sha256:1e42bbe2508154c9126d48c2b8a75420c3544343bf86fd041fb7527e017a4b4a

HEALTHCHECK CMD ["/usr/bin/curl", "--socks5", "localhost:9050", "--socks5-hostname", "localhost:9050", "https://check.torproject.org/api/ip"]

# hadolint ignore=DL3018
RUN apk --update --no-cache add bash gettext tor \
    && rm -rf /var/cache/apk/* \
    && chmod o+rwx /etc/tor

USER "tor"

COPY torrc.template tor-wrapper.sh /etc/tor/

WORKDIR "/var/lib/tor"

EXPOSE 9050

CMD ["/etc/tor/tor-wrapper.sh"]
ENTRYPOINT []
