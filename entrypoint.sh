#!/bin/sh

sed -i'' "s/127\.0\.0\.1:8118/0\.0\.0\.0:$LOCAL_HTTP_PORT/" /etc/privoxy/config
echo "forward-socks5  /       127.0.0.1:$LOCAL_SS_PORT  ." >> /etc/privoxy/config

{ \
 echo "{"; \
 echo "   \"server\":\"$SERVER_IP\","; \
 echo "   \"server_port\":$SERVER_PORT,"; \
 echo "   \"local_port\":$LOCAL_SS_PORT,"; \
 echo "   \"password\":\"$PASSWORD\","; \
 echo "   \"timeout\":180,"; \
 echo "   \"method\":\"$ENCRYPTION\""; \
 echo "}"; \
} > /etc/shadowsocks-libev/config.json

privoxy /etc/privoxy/config
ss-local -b 0.0.0.0 -u --fast-open -c /etc/shadowsocks-libev/config.json
