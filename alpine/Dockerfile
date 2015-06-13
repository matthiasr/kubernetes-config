FROM alpine:latest

RUN apk --update add dropbear bash
RUN adduser -h /home/mr -s /bin/bash -u 1000 -D mr
RUN echo '/bin/bash' >> /etc/shells

VOLUME /etc/dropbear
VOLUME /home/mr
WORKDIR /home/mr
EXPOSE 22
CMD dropbear -F -E -g -B -a -r /etc/dropbear/rsa -r /etc/dropbear/ecdsa -r /etc/dropbear/dss
