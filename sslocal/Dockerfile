FROM alpine

MAINTAINER zf724 <zf724@qq.com> 

ARG TZ='Asia/Shanghai'

ENV TZ $TZ
ENV SS_LIBEV_VERSION 3.1.3
ENV KCP_VERSION 20171201
ENV SS_DOWNLOAD_URL https://github.com/zf724/docker-ss/blob/master/sscommon/shadowsocks-libev-${SS_LIBEV_VERSION}.tar.gz?raw=true
ENV OBFS_DOWNLOAD_URL https://github.com/shadowsocks/simple-obfs.git

ENV SERVER_IP 127.0.0.1
ENV SERVER_PORT 8888
ENV PASSWORD password
ENV ENCRYPTION aes-256-cfb
ENV LOCAL_SS_PORT 1080
ENV LOCAL_HTTP_PORT 8118

RUN apk upgrade --update \
    && apk add  --no-cache bash tzdata libsodium privoxy \
    && apk add --virtual .build-deps \
        autoconf \
        automake \
        asciidoc \
        xmlto \
        build-base \
        curl \
        c-ares-dev \
        libev-dev \
        libtool \
        linux-headers \
        udns-dev \
        libsodium-dev \
        mbedtls-dev \
        pcre-dev \
        udns-dev \
        tar \
        git \
    && mkdir -p /etc/shadowsocks-libev

RUN curl -sSL -o shadowsocks-libev-${SS_LIBEV_VERSION}.tar.gz ${SS_DOWNLOAD_URL} \
    && tar -zxf shadowsocks-libev-${SS_LIBEV_VERSION}.tar.gz \
    && (cd shadowsocks-libev-${SS_LIBEV_VERSION} \
    && ./configure --prefix=/usr --disable-documentation \
    && make install) \
    && git clone ${OBFS_DOWNLOAD_URL} \
    && (cd simple-obfs \
    && git submodule update --init --recursive \
    && ./autogen.sh && ./configure \
    && make && make install) \
    && ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    && runDeps="$( \
        scanelf --needed --nobanner /usr/bin/ss-* /usr/local/bin/obfs-* \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | xargs -r apk info --installed \
            | sort -u \
        )" \
    && apk add --virtual .run-deps $runDeps \
    && apk del .build-deps \
    && rm -rf shadowsocks-libev-${SS_LIBEV_VERSION}.tar.gz \
        shadowsocks-libev-${SS_LIBEV_VERSION} \
        simple-obfs \
        /var/cache/apk/*

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE $LOCAL_SS_PORT $LOCAL_HTTP_PORT

ENTRYPOINT ["/entrypoint.sh"]
