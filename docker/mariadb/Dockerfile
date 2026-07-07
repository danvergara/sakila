ARG VERSION="10.6"

FROM mariadb:${VERSION}

ENV MYSQL_DATABASE=sakila
ENV MYSQL_USER=sakila
ENV MYSQL_PASSWORD=sakila
ENV MYSQL_ROOT_PASSWORD=sakila

# Copy initialization SQL into the entrypoint directory so it runs at first startup
COPY mysql-sakila-db/mysql-sakila-schema.sql /docker-entrypoint-initdb.d/01-schema.sql
COPY mysql-sakila-db/mysql-sakila-insert-data.sql /docker-entrypoint-initdb.d/02-data.sql

EXPOSE 3306
