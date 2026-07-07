ARG VERSION="2017-latest"

FROM mcr.microsoft.com/mssql/server:${VERSION} AS builder

ENV ACCEPT_EULA=Y
ENV MSSQL_SA_PASSWORD=S4kila2026
ENV MSSQL_DBNAME=sakila

# Copy initialization SQL into the entrypoint directory so it runs at first startup
COPY sql-server-sakila-db/sql-server-sakila-schema.sql /01-schema.sql
COPY sql-server-sakila-db/sql-server-sakila-insert-data.sql /02-data.sql
COPY docker/mssql/insert.sh /insert.sh

# Initialize SQL Server once during the build and leave the populated data directory intact
RUN /insert.sh

FROM mcr.microsoft.com/mssql/server:${VERSION}

ENV ACCEPT_EULA=Y
ENV MSSQL_SA_PASSWORD=S4kila2026
ENV MSSQL_DBNAME=sakila

COPY --from=builder /var/opt/mssql/data/ /var/opt/mssql/data/

EXPOSE 1433
