FROM alpine:edge
MAINTAINER SgrAlpha <admin@mail.sgr.io> 

ENV SERVER_IP 127.0.0.1
ENV SERVER_PORT 8888
ENV LOCAL_SS_PORT 1080
ENV LOCAL_HTTP_PORT 8118
ENV PASSWORD password
ENV ENCRYPTION aes-256-cfb

RUN set -ex && \
	echo 'http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories && \
	apk --update add --no-cache \
		curl \
		privoxy \
		libsodium \
		mbedtls \
		libcrypto1.0 \
		udns \
		pcre \
		libev \
		shadowsocks-libev && \
	mkdir -p /etc/shadowsocks-libev

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE $LOCAL_SS_PORT $LOCAL_HTTP_PORT

ENTRYPOINT ["/entrypoint.sh"]
