# docker-tor

Run TOR conveniently from a docker container.

```
docker run --rm -p 9050:9050 thomasleplus/tor
```

Once the docker container has finished starting, you can test it with the following command:

```
curl --socks5 localhost:9050 --socks5-hostname localhost:9050 https://check.torproject.org/
```

