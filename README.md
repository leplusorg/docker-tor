# docker-tor

Run TOR conveniently from a docker container.

[![Docker Build](https://github.com/thomasleplus/docker-tor/workflows/Docker/badge.svg)](https://github.com/thomasleplus/docker-tor/actions?query=workflow:"Docker")
[![Docker Stars](https://img.shields.io/docker/stars/thomasleplus/tor)](https://hub.docker.com/r/thomasleplus/tor)
[![Docker Pulls](https://img.shields.io/docker/pulls/thomasleplus/tor)](https://hub.docker.com/r/thomasleplus/tor)
[![Docker Automated](https://img.shields.io/docker/cloud/automated/thomasleplus/tor)](https://hub.docker.com/r/thomasleplus/tor)
[![Docker Build](https://img.shields.io/docker/cloud/build/thomasleplus/tor)](https://hub.docker.com/r/thomasleplus/tor)
[![Docker Version](https://img.shields.io/docker/v/thomasleplus/tor?sort=semver)](https://hub.docker.com/r/thomasleplus/tor)

```
docker run --rm -p 9050:9050 thomasleplus/tor
```

Once the docker container has finished starting, you can test it with the following command:

```
curl --socks5 localhost:9050 --socks5-hostname localhost:9050 https://check.torproject.org/
```

## Request configuration change

Please use [this link](https://github.com/thomasleplus/docker-tor/issues/new?assignees=thomasleplus&labels=enhancement&template=feature_request.md&title=%5BFEAT%5D) (GitHub account required) to suggest a change in this image configuration.
