# TOR

Run TOR conveniently from a docker container.

[![Docker Build](https://github.com/leplusorg/docker-tor/workflows/Docker/badge.svg)](https://github.com/leplusorg/docker-tor/actions?query=workflow:"Docker")
[![Docker Stars](https://img.shields.io/docker/stars/leplusorg/tor)](https://hub.docker.com/r/leplusorg/tor)
[![Docker Pulls](https://img.shields.io/docker/pulls/leplusorg/tor)](https://hub.docker.com/r/leplusorg/tor)
[![Docker Version](https://img.shields.io/docker/v/leplusorg/tor?sort=semver)](https://hub.docker.com/r/leplusorg/tor)

```bash
docker run --rm -p 9050:9050 leplusorg/tor
```

Once the docker container has finished starting, you can test it with the following command:

```bash
curl --socks5 localhost:9050 --socks5-hostname localhost:9050 https://check.torproject.org/api/ip
```

## Request configuration change

Please use [this link](https://github.com/leplusorg/docker-tor/issues/new?assignees=thomasleplus&labels=enhancement&template=feature_request.md&title=%5BFEAT%5D) (GitHub account required) to suggest a change in this image configuration.
