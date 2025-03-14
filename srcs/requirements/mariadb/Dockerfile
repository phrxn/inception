FROM alpine:3.21.3

ARG DATABASE
ARG DATABASE_ROOT
ARG DATABASE_ROOT_PASSWORD
ARG DATABASE_USER
ARG DATABASE_USER_PASSWORD

COPY ./conf/my.cnf /etc/my.cnf
COPY ./tools/configure-db.sh /tmp/configure-db.sh

RUN apk update && apk add --no-cache mariadb mariadb-client \
    && mkdir -p /var/lib/mysqld /var/run/mysqld \
    && chown -R mysql:mysql /var/run/mysqld /var/lib/mysqld \
    && chmod -R 777 /var/run/mysqld \
    && chmod a+x /tmp/configure-db.sh \
    && ash -f /tmp/configure-db.sh \
    && rm -rf /tmp/configure-db.sh

EXPOSE 3306

ENTRYPOINT ["mariadbd-safe"]
