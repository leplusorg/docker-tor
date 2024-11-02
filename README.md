# TOR

Run TOR conveniently from a docker container.

[![Dockerfile](https://img.shields.io/badge/GitHub-Dockerfile-blue)](https://github.com/leplusorg/docker-tor/blob/main/tor/Dockerfile)
[![Docker Build](https://github.com/leplusorg/docker-tor/workflows/Docker/badge.svg)](https://github.com/leplusorg/docker-tor/actions?query=workflow:"Docker")
[![Docker Stars](https://img.shields.io/docker/stars/leplusorg/tor)](https://hub.docker.com/r/leplusorg/tor)
[![Docker Pulls](https://img.shields.io/docker/pulls/leplusorg/tor)](https://hub.docker.com/r/leplusorg/tor)
[![Docker Version](https://img.shields.io/docker/v/leplusorg/tor?sort=semver)](https://hub.docker.com/r/leplusorg/tor)

## Usage

The simplest way to launch a TOR proxy using this container is to use the following command:

```bash
docker run --rm -p 9050:9050 leplusorg/tor
```

If you need to ovverride the default [torrc](tor/torrc) file, you can mount your version this way:

```bash
docker run --rm -p 9050:9050 -v /local/path/to/your/torrc:/etc/torrc leplusorg/tor
```

Once the docker container has finished starting, you can test it with the following command:

```bash
curl --socks5 localhost:9050 --socks5-hostname localhost:9050 https://check.torproject.org/api/ip
```

## Configuration

The configuration file used by Tor in this container is
`/et/tor/torrc` but it is generated on startup by the script
`tor-wrapper.sh` using the `torrc.template` file. The file is based on
the `torrc.sample` configuration that comes with Tor. But some
configuration options have been made configurable using OS environment
variables. You can set a custom value for these variables for example
using the `-e` option of Docker. Below are the variables currently
available:

| Variable name    | Usage                                                           | Default      |
| ---------------- | --------------------------------------------------------------- | ------------ |
| DATA_DIRECTORY   | The data directory.                                             | /var/lib/tor |
| LOG_LEVEL        | The logging level.                                              | notice       |
| LOG_FILE         | The log file or device.                                         | stdout       |
| SOCKS_HOSTNAME   | The SOCKS hostname.                                             | 127.0.0.0.1  |
| SOCKS_PORT       | The SOCKS port.                                                 | 9150         |
| TORRC_APPEND     | A block of configuration appended at the end of the torrc file. |              |

Note that the defaults are the same as Tor's default if the
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
`/etc/tor/torrc.d/` directory with the `.conf` extension so you can
mount your custom torrc configuration file(s) there. This is similar
to the `TORRC_APPEND` environment variable but using files instead.

For troubleshooting, you can enable verbose logging by setting the
value of environment variable `DEBUG` to `true`.

## Request configuration change

Please use [this link](https://github.com/leplusorg/docker-tor/issues/new?assignees=thomasleplus&labels=enhancement&template=feature_request.md&title=%5BFEAT%5D) (GitHub account required) to suggest a change in this image configuration or to expose a new Tor configuration option.
