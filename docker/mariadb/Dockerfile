ARG VERSION="10.6"

FROM mariadb:${VERSION} AS builder

ENV MYSQL_DATABASE=sakila
ENV MYSQL_USER=sakila
ENV MYSQL_PASSWORD=sakila
ENV MYSQL_ROOT_PASSWORD=sakila

# Copy initialization SQL into the entrypoint directory so it runs at first startup
COPY mysql-sakila-db/mysql-sakila-schema.sql /01-schema.sql
COPY mysql-sakila-db/mysql-sakila-insert-data.sql /02-data.sql
COPY docker/mariadb/insert.sh /insert.sh

# Initialize MySQL once during the build and leave the populated data directory intact
RUN chmod +x /insert.sh
RUN /insert.sh

FROM mariadb:${VERSION}

ENV MYSQL_DATABASE=sakila
ENV MYSQL_USER=sakila
ENV MYSQL_PASSWORD=sakila
ENV MYSQL_ROOT_PASSWORD=sakila

COPY --from=builder /var/lib/mysql/ /var/lib/mysql/

EXPOSE 3306
