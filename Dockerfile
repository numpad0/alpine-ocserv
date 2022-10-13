From alpine:latest
MAINTAINER numpad0

RUN echo "@edge http://dl-4.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories
RUN echo "@testing http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk update && apk add musl-dev iptables gnutls-dev readline-dev libnl3-dev lz4-dev libseccomp-dev@testing
RUN apk add gnutls libev libev-dev gnutls-utils nettle libprotobuf libev-dev

RUN buildDeps="xz openssl gcc autoconf make linux-headers patch"; \
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
	&& rm -fr ./$OC_FILE \
	&& apk del --purge $buildDeps

COPY ocserv.conf /etc/ocserv/ocserv.conf

WORKDIR /etc/ocserv

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 443
CMD ["ocserv", "-c", "/etc/ocserv/ocserv.conf", "-f"]
