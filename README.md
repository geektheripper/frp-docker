# frp Docker Image

## What is frp

frp is a fast reverse proxy to help you expose a local server behind a NAT or firewall to the internet. Now, it supports tcp, udp, http and https protocol when requests can be forwarded by domains to backward web services.

you can visit https://github.com/fatedier/frp for know more

## How to use this image

a config file is necessary for this image, you can [read the doc](https://github.com/fatedier/frp/blob/master/README.md) to know how to write it.

### Start a frp server

```shell
$ docker run -d --network=host -v /path/to/frps.ini:/etc/frp/frps.ini:ro geektr/frp
## `--network=host` means the docker container run on host network
```

### Start a frp client

```shell
$ docker run -d --network=host -v /path/to/frpc.ini:/etc/frp/frpc.ini:ro geektr/frp
## `--network=host` means the docker container run on host network
```

### Frp mode

this image can run as both frp server and frp client
what it will run depends on environment variables and config file

``` shell
# /somepath/
# └── config
#     ├── frpc.ini
#     └── frps.ini

# first , it depends depend on config file

$ docker run -d --network=host -v /somepath/config/frps.ini:/etc/frp/frps.ini:ro geektr/frp
# => this command start a frp server

$ docker run -d --network=host -v /somepath/config/frpc.ini:/etc/frp/frpc.ini:ro geektr/frp
# => this command start a frp client

$ docker run -d --network=host -v /somepath/config:/etc/frp:ro geektr/frp
# => this command start both server and client

# you can pass an enviroment variable 'FRP_MODE' to force what it run, 'FRP_MODE' can be set to 'frpc', 'frp-client', 'frps', 'frp-server' and 'both'
$ docker run -d --network=host --env FRP_MODE=frps -v /somepath/config:/etc/frp:ro geektr/frp
# => this command start a frp server
```

## With Docker Compose

when this image runs, it will replace all shell like variables to their environment value, this feature may helps in auto deploy and authority control.

### An frp server demo

docker-compose.yml

```yml
version: '3'
services:
  frp_server:
    image: geektr/frp
    environment:
      - FRP_SERVER_ADDR=${HOST_IP}
      - FRP_PRIVILEGE_TOKEN=${FRP_TOKEN}
    restart: always
    network_mode: "host"
    volumes:
      - ./frps.ini:/etc/frp/frps.ini:ro
```

frps.ini

```ini
[common]
bind_addr = ${FRP_SERVER_ADDR}
bind_port = 7000
bind_udp_port = 7001
privilege_token = ${FRP_PRIVILEGE_TOKEN}
```

.env

```env
HOST_IP=xxx.xxx.xxx.xxx
FRP_TOKEN=xxxxxxxxxxxxxxxxxxxx
```

### An frp client demo

tips: `local_ip` field support hostname, so you can use `container_name` in `frpc.ini`

docker-compose.yml

```yml
version: '3'
services:
  web_server:
    image: nginx
    container_name: web_server
    expose:
      - "80"
      - "443"
  frp_client:
    image: geektr/frp
    environment:
      - FRP_SERVER_ADDR=${HOST_IP}
      - FRP_PRIVILEGE_TOKEN=${FRP_TOKEN}
    restart: always
    volumes:
      - ./frpc.ini:/etc/frp/frpc.ini:ro
```

frps.ini

```ini
[common]
server_addr = ${FRP_SERVER_ADDR}
server_port = 7000
protocol = kcp
privilege_token = ${FRP_PRIVILEGE_TOKEN}
tcp_mux = true
pool_count = 5

[http]
type = tcp
local_ip = web_server
local_port = 80
remote_port = 80

[https]
type = tcp
local_ip = web_server
local_port = 443
remote_port = 443
```

.env

```env
HOST_IP=xxx.xxx.xxx.xxx
FRP_TOKEN=xxxxxxxxxxxxxxxxxxxx
```
