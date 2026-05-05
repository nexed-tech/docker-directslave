FROM alpine:3.23.4
LABEL org.opencontainers.image.source=https://github.com/nexed-tech/docker-directslave
ARG dsversion=3.5.1

COPY entry.sh /

RUN apk --no-cache update && \
    apk --no-cache add bash bind supervisor certbot openssl wget && \
    rm -rf /tmp/* /var/tmp/* && \
    mkdir /var/cache/bind && \
    chown -R named:named /var/bind /etc/bind /var/run/named /var/cache/bind && \
    chmod -R o-rwx /var/bind /etc/bind /var/run/named /var/cache/bind && \
    mkdir /etc/supervisor.d && \
    wget https://directslave.com/download/directslave-$dsversion-advanced-all.tar.gz && \
    tar -xf directslave-$dsversion-advanced-all.tar.gz --directory /usr/local && \
    rm directslave-$dsversion-advanced-all.tar.gz && \
    rm /usr/local/directslave/bin/directslave-freebsd-amd64 \
    /usr/local/directslave/bin/directslave-freebsd-i386 \
    /usr/local/directslave/bin/directslave-linux-arm \
    /usr/local/directslave/bin/directslave-linux-i386 \
    /usr/local/directslave/bin/directslave-macos-amd64 && \
    chmod +x /usr/local/directslave/bin/* && \
    chown -R named:named /usr/local/directslave && \
    sed -i 's/\r//' /entry.sh && chmod +x /entry.sh

COPY named.conf /etc/bind/
COPY directslave.conf /usr/local/directslave/etc/
COPY supervisord.conf /etc/supervisor.d/

HEALTHCHECK CMD wget -q --spider http://localhost:2222/ || exit 1
ENTRYPOINT ["/entry.sh"]
EXPOSE 80/tcp 53/udp 53/tcp 2222/tcp 2224/tcp
