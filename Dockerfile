FROM alpine:latest
MAINTAINER Simon Krenz <sk@4nx.io>

LABEL Description="GCHQ CyberChef Docker Container"

RUN apk update && apk upgrade && \
    apk add --no-cache busybox-suid curl git nginx nodejs npm && \
    npm i npm@latest -g && \
    npm install -g grunt-cli && \
    addgroup -S cyberchef && adduser -S cyberchef -G cyberchef

USER cyberchef

RUN git clone https://github.com/gchq/CyberChef.git /home/cyberchef

WORKDIR /home/cyberchef

RUN npm install && \
    npm audit fix && \
    grunt prod

USER root

EXPOSE 80/tcp

COPY config /config
COPY ./docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

VOLUME ["/etc/nginx", "/etc/ssl", "/var/log/nginx"]

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
