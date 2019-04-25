FROM alpine:latest

ARG GNUNET_REVISION=ed649403902b055935308ee7a244e2d3ba081301

RUN apk add --update wget alpine-sdk automake autoconf libtool libltdl gmp-dev libgcrypt-dev glib-dev libunistring-dev libidn-dev linux-headers jansson-dev libmicrohttpd-dev gnutls-dev sqlite-dev libidn-dev && rm -rf /var/cache/apk/* /tmp/*

WORKDIR /opt

RUN wget -q https://ftp.gnu.org/gnu/gnunet/gnurl-7.57.0.tar.bz2 -O gnurl.tar.bz2 && mkdir gnurl && tar xf gnurl.tar.bz2 -C gnurl --strip-components 1 && cd gnurl && autoreconf -i && ./configure --prefix=/opt --disable-ntlm-wb --with-gnutls && make install && rm -rf /opt/gnurl*

RUN wget -q ftp://ftp.gnu.org/gnu/libextractor/libextractor-1.7.tar.gz && tar xvzpf libextractor-1.7.tar.gz && cd libextractor-1.7 && ./configure --prefix=/opt && make install && rm -rf /opt/libextractor*

RUN wget -q ftp://ftp.gnu.org/gnu/glpk/glpk-4.55.tar.gz && tar xvzpf glpk-4.55.tar.gz && cd glpk-4.55 && ./configure --prefix=/opt && make install && rm -rf /opt/glpk-4.55*

RUN cp -r /opt/* /usr

RUN git clone https://gnunet.org/git/gnunet.git && cd gnunet && git checkout $GNUNET_REVISION && ./bootstrap && ./configure --help && ./configure --enable-experimental --prefix=/opt --disable-documentation --with-microhttpd --with-extractor=/opt --with-libgnurl=/opt && make && make install && rm -rf /opt/gnunet/

FROM alpine:latest

WORKDIR /opt

RUN apk add --update ca-certificates openssl libbz2 libtool libltdl libunistring libidn jansson libmicrohttpd gnutls sqlite-dev glib libgcrypt gmp && update-ca-certificates && rm -rf /var/cache/apk/* /tmp/*

EXPOSE 7777

COPY docker-entrypoint.sh /opt

COPY --from=0 /opt /usr/

CMD [ "/opt/docker-entrypoint.sh" ]



