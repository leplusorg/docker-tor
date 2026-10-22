# TOR image

Build context for the `leplusorg/tor` container image. See the
[root readme](../README.md) for what the image does and how to run it.

## Files

- `Dockerfile` — the image definition. Its entrypoint is `tor-wrapper.sh`.
  System packages come from the base distribution's package manager and are
  pinned to exact versions here.
- `docker-compose.test.yml` — the test run in CI: starts the built image as the
  `tor` service, and a client built from `Dockerfile-test` as the `sut` service.
- `Dockerfile-test` — the test client image. After 60 seconds (so the Tor
  container has gone through its own healthcheck) it fetches
  <https://check.torproject.org/api/ip> through the `tor` service's SOCKS proxy.
- `tor-wrapper.sh` — the entrypoint, copied to `/etc/tor/`. It generates
  `/etc/tor/torrc` from `torrc.template` with `envsubst` (unless
  `SKIP_TEMPLATE=true`), restricts the permissions of the data directory (unless
  `SET_PERMISSIONS=false`), then runs `tor`.
- `torrc.template` — the Tor configuration template, copied to `/etc/tor/`. Its
  `${...}` placeholders (`SOCKS_HOSTNAME`, `SOCKS_PORT`, `LOG_LEVEL`,
  `LOG_FILE`, `DATA_DIRECTORY`, `TORRC_APPEND`) are filled from environment
  variables, and it includes any `/etc/torrc.d/*.conf` file.

This image has no package manifest: everything in it comes from the base
distribution's package manager, at the versions pinned in the `Dockerfile`.
