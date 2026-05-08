FROM alpine:3.23.4
LABEL org.opencontainers.image.source=https://github.com/nexed-tech/docker-directslave
ARG dsversion=3.5.1

COPY entry.sh /

RUN apk --no-cache update && \
    apk --no-cache add bash bind certbot openssl wget && \
    rm -rf /tmp/* /var/tmp/* && \
    mkdir -p /var/cache/bind && \
    chown -R named:named /var/bind /etc/bind /var/run/named /var/cache/bind && \
    chmod -R o-rwx /var/bind /etc/bind /var/run/named /var/cache/bind && \
    wget https://directslave.com/download/directslave-$dsversion-advanced-all.tar.gz && \
    tar -xf directslave-$dsversion-advanced-all.tar.gz --directory /usr/local && \
    rm directslave-$dsversion-advanced-all.tar.gz && \
    find /usr/local/directslave/bin -type f ! -name 'directslave-linux-amd64' -delete && \
    chmod +x /usr/local/directslave/bin/* && \
    chown -R named:named /usr/local/directslave && \
    sed -i 's/\r//' /entry.sh && chmod +x /entry.sh

COPY named.conf /etc/bind/
COPY directslave.conf /usr/local/directslave/etc/

HEALTHCHECK CMD wget -q --spider http://localhost:2222/ || exit 1
ENTRYPOINT ["/entry.sh"]
EXPOSE 80/tcp 53/udp 53/tcp 2222/tcp 2224/tcp
