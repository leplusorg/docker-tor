FROM alpine:3.21.3@sha256:a8560b36e8b8210634f77d9f7f9efd7ffa463e380b75e2e74aff4511df3ef88c

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
