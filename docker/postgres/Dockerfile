ARG VERSION="14-alpine"

FROM postgres:${VERSION} AS builder

ENV POSTGRES_DB=sakila
ENV POSTGRES_USER=sakila
ENV POSTGRES_PASSWORD=sakila
ENV PGDATA=/var/lib/postgresql/data

# Copy initialization SQL into the entrypoint directory so it runs during image build
COPY postgres-sakila-db/postgres-sakila-schema.sql /docker-entrypoint-initdb.d/01-schema.sql
COPY postgres-sakila-db/postgres-sakila-insert-data-using-copy.sql /docker-entrypoint-initdb.d/02-data-copy.sql
COPY docker/postgres/insert.sh /insert.sh

# Initialize PostgreSQL once during the build and leave the populated data directory intact
RUN chmod +x /insert.sh
RUN /insert.sh

FROM postgres:${VERSION}
ENV POSTGRES_DB=sakila
ENV POSTGRES_USER=sakila
ENV POSTGRES_PASSWORD=sakila
ENV PGDATA=/var/lib/postgresql/data

COPY --from=builder /var/lib/postgresql/data/ /var/lib/postgresql/data/

EXPOSE 5432
