FROM alpine:3.20.3@sha256:beefdbd8a1da6d2915566fde36db9db0b524eb737fc57cd1367effd16dc0d06d

HEALTHCHECK CMD ["/usr/bin/curl", "--socks5", "localhost:9050", "--socks5-hostname", "localhost:9050", "https://check.torproject.org/api/ip"]

# hadolint ignore=DL3018
RUN apk --update --no-cache add gettext tor \
    && rm -rf /var/cache/apk/*

COPY torrc.template /etc/tor/torrc.template

COPY tor-wrapper.sh /etc/tor/tor-wrapper.sh

USER "tor"

WORKDIR "/var/lib/tor"

EXPOSE 9050

ENTRYPOINT ["/etc/tor/tor-wrapper.sh"]
