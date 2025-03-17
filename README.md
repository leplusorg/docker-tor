# TOR

Run TOR conveniently from a docker container.

[![Dockerfile](https://img.shields.io/badge/GitHub-Dockerfile-blue)](tor/Dockerfile)
[![Docker Build](https://github.com/leplusorg/docker-tor/workflows/Docker/badge.svg)](https://github.com/leplusorg/docker-tor/actions?query=workflow:"Docker")
[![Docker Stars](https://img.shields.io/docker/stars/leplusorg/tor)](https://hub.docker.com/r/leplusorg/tor)
[![Docker Pulls](https://img.shields.io/docker/pulls/leplusorg/tor)](https://hub.docker.com/r/leplusorg/tor)
[![Docker Version](https://img.shields.io/docker/v/leplusorg/tor?sort=semver)](https://hub.docker.com/r/leplusorg/tor)
[![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/8752/badge)](https://bestpractices.coreinfrastructure.org/projects/8752)
[![OpenSSF Scorecard](https://api.securityscorecards.dev/projects/github.com/leplusorg/docker-tor/badge)](https://securityscorecards.dev/viewer/?uri=github.com/leplusorg/docker-tor)

## Usage

### To use the containerized TOR proxy from your host machine

The simplest way to launch a TOR proxy using this container accessible
from your host machine only is to use the following command:

```bash
docker run --rm -p 127.0.0.1:9050:9050 -e SOCKS_HOSTNAME=0.0.0.0 leplusorg/tor
```

If you want the TOR proxy to be reachable from other machines on your
network (i.e. share it), you can run:

```bash
docker run --rm -p 0.0.0.0:9050:9050 -e SOCKS_HOSTNAME=0.0.0.0 leplusorg/tor
```

Then make sure that your firewall rules allow remote connection to
your port 9050.

Once the docker container has finished starting, you can test it with the following command:

```bash
curl --socks5 localhost:9050 --socks5-hostname localhost:9050 https://check.torproject.org/api/ip
```

### To use the containerized TOR proxy from other containers

In that use case, you can use `docker compose` with a compose file
similar to this (where `bar`'s definition should be replaced by the
container that you actually want to run using TOR):

```YAML
---
version: "3.8"

services:
  tor:
    image: leplusorg/tor:latest
    environment:
      - SOCKS_HOSTNAME=0.0.0.0
  bar:
    image: foo/bar:latest
    links:
      - tor
    environment:
      - ALL_PROXY=socks5://tor:9050
```

Note that ALL_PROXY is not always honored by applications so depending
on the container that you are running, you should read its
documentation to figure out the proper way to tell it to use
`tor:9050` as a proxy. If this is misconfigured, everything might look
like it's working but the TOR proxy is not actually being used!

## Configuration

### Torrc

The configuration file used by TOR in this container is
`/et/tor/torrc` but it is generated on startup by the script
`tor-wrapper.sh` using the `torrc.template` file. The file is based on
the `torrc.sample` configuration that comes with TOR. But some
configuration options have been made configurable using OS environment
variables. You can set a custom value for these variables for example
using the `-e` option of Docker. Below are the variables currently
available:

| Variable name  | Usage                                                           | Default      |
| -------------- | --------------------------------------------------------------- | ------------ |
| DATA_DIRECTORY | The data directory.                                             | /var/lib/tor |
| LOG_LEVEL      | The logging level.                                              | notice       |
| LOG_FILE       | The log file or device.                                         | stdout       |
| SOCKS_HOSTNAME | The SOCKS hostname.                                             | 127.0.0.0.1  |
| SOCKS_PORT     | The SOCKS port.                                                 | 9150         |
| TORRC_APPEND   | A block of configuration appended at the end of the torrc file. |              |

Note that the defaults are the same as TOR's default if the
configuration option is not set.

You can use the `-m` option of Docker to mount a custom template in the
image at `/etc/tor/torrc.template`. The templating engine
(`envsubst`) will only replace specific environment variables in the
template. These are controlled by the environment variable
`SHELL_FORMAT` (the default list is
`${DATA_DIRECTORY},${LOG_LEVEL},${LOG_FILE},${SOCKS_HOSTNAME},${SOCKS_PORT}`). If
you create a custom template with extra variables in it, you can set
your own list using the environment variable `SHELL_FORMAT` or you can
just append the extra variables to the existing list using the
environment variable `SHELL_FORMAT_EXTRA`. Be careful to escape the
`$` characters since you don't want them to be interpolated when
defining `SHELL_FORMAT` or `SHELL_FORMAT_EXTRA`.

The out-of-the-box torrc.template also loads any file in the
`/etc/torrc.d/` directory with the `.conf` extension so you can
mount your custom torrc configuration file(s) there. This is similar
to the `TORRC_APPEND` environment variable but using files instead.

If you set the `SKIP_TEMPLATE` variable to `true`, the whole
templating logic will be disabled and the configuration file
/etc/tor/torrc will be used. In that case you must provide that file
by mounting it (or adding it to your custom image built from this
one). Otherwise TOR will refuse to start with the following messages:

```Text
[warn] Unable to open configuration file "/etc/tor/torrc".
[err] Reading config failed--see warnings above
```

### Permissions

By default `tor-wrapper.sh` will adjust the permissions on the data
directory to avoid a warning on start up that says `Fixing permissions
on directory ...`. This can be disabled by setting the value of
environment variable `SET_PERMISSIONS` to `false`.

### Debugging

For troubleshooting, you can enable verbose logging by setting the
value of environment variable `DEBUG` to `true`.

## Software Bill of Materials (SBOM)

To get the SBOM for the latest image (in SPDX JSON format), use the
following command:

```bash
docker buildx imagetools inspect leplusorg/tor --format '{{ json (index .SBOM "linux/amd64").SPDX }}'
```

Replace `linux/amd64` by the desired platform (`linux/amd64`, `linux/arm64` etc.).

### Sigstore

[Sigstore](https://docs.sigstore.dev) is trying to improve supply
chain security by allowing you to verify the origin of an
artifcat. You can verify that the jar that you use was actually
produced by this repository. This means that if you verify the
signature of the ristretto jar, you can trust the integrity of the
whole supply chain from code source, to CI/CD build, to distribution
on Maven Central or whever you got the jar from.

You can use the following command to verify the latest image using its
sigstore signature attestation:

```bash
cosign verify leplusorg/tor --certificate-identity-regexp 'https://github\.com/leplusorg/docker-tor/\.github/workflows/.+' --certificate-oidc-issuer 'https://token.actions.githubusercontent.com'
```

The output should look something like this:

```text
Verification for index.docker.io/leplusorg/xml:main --
The following checks were performed on each of these signatures:
  - The cosign claims were validated
  - Existence of the claims in the transparency log was verified offline
  - The code-signing certificate was verified using trusted certificate authority certificates

[{"critical":...
```

For instructions on how to install `cosign`, please read this [documentation](https://docs.sigstore.dev/cosign/system_config/installation/).

## Request configuration change

Please use [this link](https://github.com/leplusorg/docker-tor/issues/new?assignees=thomasleplus&labels=enhancement&template=feature_request.md&title=%5BFEAT%5D) (GitHub account required) to suggest a change in this image configuration or to expose a new TOR configuration option.
