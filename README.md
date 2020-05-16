# docker-tor

Run TOR conveniently from a docker container.

![GitHub Build](https://img.shields.io/github/workflow/status/thomasleplus/docker-tor/Docker%20Image%20CI)
![Docker Stars](https://img.shields.io/docker/stars/thomasleplus/tor)
![Docker Pulls](https://img.shields.io/docker/pulls/thomasleplus/tor)
![Docker Automated](https://img.shields.io/docker/cloud/automated/thomasleplus/tor)
![Docker Build](https://img.shields.io/docker/cloud/build/thomasleplus/tor)
![Docker Version](https://img.shields.io/docker/v/thomasleplus/tor?sort=semver)

```
docker run --rm -p 9050:9050 thomasleplus/tor
```

Once the docker container has finished starting, you can test it with the following command:

```
curl --socks5 localhost:9050 --socks5-hostname localhost:9050 https://check.torproject.org/
```

## Request configuration change

Please use [this link](https://github.com/thomasleplus/docker-tor/issues/new?assignees=thomasleplus&labels=enhancement&template=feature_request.md&title=%5BFEAT%5D) (GitHub account required) to suggest a change in this image configuration.
