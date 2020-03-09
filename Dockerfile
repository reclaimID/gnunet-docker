FROM alpine:edge

RUN apk update && apk upgrade && apk add --repository "http://dl-cdn.alpinelinux.org/alpine/edge/testing/" --update gnunet && rm -rf /var/cache/apk/* /tmp/*

WORKDIR /opt

EXPOSE 7777

COPY docker-entrypoint.sh /opt

CMD [ "/opt/docker-entrypoint.sh" ]

