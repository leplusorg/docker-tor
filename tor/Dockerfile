FROM alpine:3.22.0@sha256:8a1f59ffb675680d47db6337b49d22281a139e9d709335b492be023728e11715

SHELL ["/bin/ash", "-euo", "pipefail", "-c"]

HEALTHCHECK CMD ["/usr/bin/curl", "--socks5", "localhost:9050", "--socks5-hostname", "localhost:9050", "https://check.torproject.org/api/ip"]

# hadolint ignore=DL3019
RUN apk -U upgrade \
    && apk add \
    bash=5.2.37-r0 \
    curl=8.14.1-r0 \
    gettext=0.24.1-r0 \
    tor=0.4.8.16-r0 \
    && if apk -u list | grep -q -e . ; then \
      apk -u list ; \
      exit 1 ; \
    fi \
    && apk cache clean \
    && rm -rf /var/cache/apk/*

RUN chmod ugo+rwx /etc/tor

COPY torrc.template tor-wrapper.sh /etc/tor/

RUN chmod ugo+rx /etc/tor/tor-wrapper.sh

USER "tor"

WORKDIR "/var/lib/tor"

EXPOSE 9050

CMD ["/etc/tor/tor-wrapper.sh"]
ENTRYPOINT []
