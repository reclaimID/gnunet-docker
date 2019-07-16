FROM alpine:edge

ARG GNUNET_REVISION=b6cfd30f7f59d686f0d12aa1b51372c452880ca9

RUN apk update && apk add --update wget alpine-sdk automake autoconf libtool libltdl gmp-dev libgcrypt-dev glib-dev libunistring-dev libidn-dev linux-headers jansson-dev libmicrohttpd-dev gnutls-dev sqlite-dev libidn-dev && rm -rf /var/cache/apk/* /tmp/*

WORKDIR /opt

RUN wget -q https://ftp.gnu.org/gnu/gnunet/gnurl-7.65.1.tar.gz -O gnurl.tar.gz && mkdir gnurl && tar xf gnurl.tar.gz -C gnurl --strip-components 1 && cd gnurl && autoreconf -i && ./configure --prefix=/opt --enable-ipv6 --with-gnutls --without-libssh2 --without-libmetalink --without-winidn --without-librtmp --without-nghttp2 --without-nss --without-cyassl --without-polarssl --without-ssl --without-winssl --without-libpsl --without-darwinssl --disable-sspi --disable-ntlm-wb --disable-ldap --disable-rtsp --disable-dict --disable-telnet --disable-tftp --disable-pop3 --disable-imap --disable-smtp --disable-gopher --disable-file --disable-ftp --disable-smb --disable-ares && make install && rm -rf /opt/gnurl*

RUN wget -q ftp://ftp.gnu.org/gnu/libextractor/libextractor-1.9.tar.gz && tar xzpf libextractor-1.9.tar.gz && cd libextractor-1.9 && ./configure --prefix=/opt && make install && rm -rf /opt/libextractor*

RUN wget -q ftp://ftp.gnu.org/gnu/glpk/glpk-4.65.tar.gz && tar xzpf glpk-4.65.tar.gz && cd glpk-4.65 && ./configure --prefix=/opt && make install && rm -rf /opt/glpk-4.65*

RUN cp -r /opt/* /usr

RUN git clone https://gnunet.org/git/gnunet.git && cd gnunet && git checkout $GNUNET_REVISION && ./bootstrap && ./configure --prefix=/opt --disable-documentation --with-microhttpd --with-extractor=/opt --with-libgnurl=/opt && make && make install && rm -rf /opt/gnunet/

FROM alpine:edge

WORKDIR /opt

RUN apk add --update ca-certificates openssl libbz2 libtool libltdl libunistring libidn jansson libmicrohttpd gnutls sqlite-dev glib libgcrypt gmp && update-ca-certificates && rm -rf /var/cache/apk/* /tmp/*

EXPOSE 7777

COPY docker-entrypoint.sh /opt

COPY --from=0 /opt /usr/

CMD [ "/opt/docker-entrypoint.sh" ]

