FROM alpine:3.8

ARG frp_version

ADD ./docker-entrypoint.sh /

RUN apk add --virtual .build-dependencies --no-cache openssl

RUN chmod +x /docker-entrypoint.sh \
  && mkdir -p /etc/frp \
  && cd /tmp \
  && wget -O frp.tar.gz "https://github.com/fatedier/frp/releases/download/v${frp_version}/frp_${frp_version}_linux_amd64.tar.gz" \
  && tar -xzf frp.tar.gz \
  && mv ./frp_${frp_version}_linux_amd64/frpc /usr/local/bin \
  && mv ./frp_${frp_version}_linux_amd64/frps /usr/local/bin \
  && rm -rf /tmp/*

RUN apk del .build-dependencies

WORKDIR /etc/frp

ENTRYPOINT ["/docker-entrypoint.sh"]
