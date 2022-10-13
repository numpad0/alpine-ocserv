From alpine:latest
MAINTAINER numpad0

RUN echo "@edge http://dl-4.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories
RUN echo "@testing http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk update && apk add musl-dev iptables gnutls-dev readline-dev libnl3-dev lz4-dev libseccomp-dev@testing

RUN buildDeps="xz openssl gcc autoconf make linux-headers"; \
	set -x \
	&& apk add $buildDeps \
	&& cd \
	&& OC_FILE="ocserv-1.1.6" \
	&& wget https://www.infradead.org/ocserv/download/ocserv-1.1.6.tar.xz \
	&& wget https://raw.githubusercontent.com/usecallmanagernz/patches/master/ocserv/cisco-webvpnlogin-1.1.6.patch \
	&& tar xJf $OC_FILE.tar.xz \
	&& rm -fr $OC_FILE.tar.xz \
	&& cd $OC_FILE \
	&& patch --strip=1 < ../cisco-webvpnlogin-1.1.6.patch \
	&& sed -i '/#define DEFAULT_CONFIG_ENTRIES /{s/96/200/}' src/vpn.h \
	&& ./configure --prefix=/usr --sysconfdir=/etc/ocserv --disable-maintainer-mode \
	&& make -j"$(nproc)" \
	&& make install \
	&& mkdir -p /etc/ocserv \
	&& cp ./doc/sample.config /etc/ocserv/ocserv.conf \
	&& cd \
	&& rm -fr ./$OC_FILE \
	&& apk del --purge $buildDeps

COPY cn-no-route.txt /tmp/
RUN set -x \
	&& sed -i 's/\.\/sample\.passwd/\/etc\/ocserv\/ocpasswd/' /etc/ocserv/ocserv.conf \
	&& sed -i 's/\(max-same-clients = \)2/\110/' /etc/ocserv/ocserv.conf \
	&& sed -i 's/\.\.\/tests/\/etc\/ocserv/' /etc/ocserv/ocserv.conf \
	&& sed -i 's/#\(compression.*\)/\1/' /etc/ocserv/ocserv.conf \
	&& sed -i '/^ipv4-network = /{s/192.168.1.0/192.168.99.0/}' /etc/ocserv/ocserv.conf \
	&& sed -i 's/192.168.1.2/8.8.8.8/' /etc/ocserv/ocserv.conf \
	&& sed -i 's/^route/#route/' /etc/ocserv/ocserv.conf \
	&& sed -i 's/^no-route/#no-route/' /etc/ocserv/ocserv.conf \
	&& cat /tmp/cn-no-route.txt >> /etc/ocserv/ocserv.conf \
	&& rm -fr /tmp/cn-no-route.txt

WORKDIR /etc/ocserv

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 443
CMD ["ocserv", "-c", "/etc/ocserv/ocserv.conf", "-f"]
