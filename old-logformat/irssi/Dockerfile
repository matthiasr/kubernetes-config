FROM debian:jessie

RUN echo 'en_US UTF-8' >> /etc/locale.gen && apt-get update && apt-get install -y irssi screen locales && apt-get clean && rm -rf /var/lib/apt/lists/*

VOLUME /srv/irc/logs/
WORKDIR /srv/irc/
COPY irssi.conf /srv/irc/irssi.conf
ENV LANG en_US.UTF-8

CMD [ "screen", "-S", "irssi", "-D", "-m", "irssi", "--config=irssi.conf" ]
# attach with: docker exec -t -i <container> env TERM=xterm script -qc 'screen -r irssi' /dev/null
# script is needed to work around https://github.com/docker/docker/issues/8755
