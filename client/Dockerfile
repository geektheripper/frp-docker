FROM alpine:3.5

ENV frp_version 0.16.1

RUN apk add --virtual .build-dependencies --no-cache openssl

RUN cd /tmp \
  && wget -O frp.tar.gz "https://github.com/fatedier/frp/releases/download/v${frp_version}/frp_${frp_version}_linux_amd64.tar.gz" \
  && tar -xzf frp.tar.gz \
  && mv ./frp_${frp_version}_linux_amd64/frpc /usr/local/bin \
  && mkdir -p /etc/frp \
  && mv ./frp_${frp_version}_linux_amd64/frpc.ini /etc/frp \
  && rm -rf /tmp

RUN apk del .build-dependencies

WORKDIR /etc/frp

ENTRYPOINT ["frpc", "-c", "/etc/frp/frpc.ini"]
