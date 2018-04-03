FROM alpine:3.5

ENV frp_version 0.16.1

RUN apk add --virtual .build-dependencies --no-cache openssl

RUN cd /tmp \
  && wget -O frp.tar.gz "https://github.com/fatedier/frp/releases/download/v${frp_version}/frp_${frp_version}_linux_amd64.tar.gz" \
  && tar -xzf frp.tar.gz \
  && mv ./frp_${frp_version}_linux_amd64/frps /usr/local/bin \
  && mkdir -p /etc/frp \
  && mv ./frp_${frp_version}_linux_amd64/frps.ini /etc/frp \
  && rm -rf /tmp

RUN apk del .build-dependencies

WORKDIR /etc/frp

EXPOSE 80 443 6000 7000 7500

ENTRYPOINT ["frps", "-c", "/etc/frp/frps.ini"]
