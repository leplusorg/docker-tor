FROM alpine:3.16.1

# hadolint ignore=DL3018
RUN apk --update --no-cache add tor \
    && rm -rf /var/cache/apk/*

COPY torrc /etc/torrc

EXPOSE 9150

ENTRYPOINT ["tor", "-f", "/etc/torrc"]
