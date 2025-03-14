FROM alpine:3.21.3

ARG DOMAIN

ENV DOMAIN=${DOMAIN}

RUN apk update \
  && \
  apk add nginx --no-cache \
    openssl \
  && \
  openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:4096 \
    -keyout /etc/ssl/certs/${DOMAIN}.key \
    -out    /etc/ssl/certs/${DOMAIN}.crt \
    -subj "/C=BR/ST=SP/L=Sao Paulo/O=42SP/CN=${DOMAIN}" \
  && \
  mkdir /var/www/wordpress/ \
    && \
    chmod 775 /var/www/wordpress/

COPY ./conf/nginx.conf /etc/nginx/nginx.conf

ENTRYPOINT [ "nginx", "-g", "daemon off;" ]
