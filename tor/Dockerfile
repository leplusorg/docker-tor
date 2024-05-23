FROM alpine:3.20.0@sha256:77726ef6b57ddf65bb551896826ec38bc3e53f75cdde31354fbffb4f25238ebd

HEALTHCHECK CMD ["/usr/bin/curl", "--socks5", "localhost:9050", "--socks5-hostname", "localhost:9050", "https://check.torproject.org/api/ip"]

# hadolint ignore=DL3018
RUN apk --update --no-cache add tor \
    && rm -rf /var/cache/apk/*

COPY torrc /etc/torrc

USER "tor"

WORKDIR "/var/lib/tor"

EXPOSE 9050

ENTRYPOINT ["/usr/bin/tor", "-f", "/etc/torrc"]
