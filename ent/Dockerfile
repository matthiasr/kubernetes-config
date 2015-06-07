FROM alpine:3.2

ENV GOPATH /go

ADD ent.tar.gz /go/src/soundcloud/

RUN apk add --update -t build-deps go git mercurial && \
  cd /go/src/soundcloud/ent* && \
  go get -d && \
  go build -o /bin/ent && \
  cd / && \
  rm -rf /var/cache/apk/* /go && \
  apk del --purge build-deps

ADD buckets /buckets

VOLUME /data
EXPOSE 80
CMD [ "/bin/ent", "-fs.root=/data", "-http.addr=:80", "-provider.dir=/buckets" ]
