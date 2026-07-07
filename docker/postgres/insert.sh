#!/bin/bash

set -e;
docker-entrypoint.sh postgres > /tmp/postgres-init.log 2>&1 & pid=$!

until pg_isready -U "$POSTGRES_USER" -d "$POSTGRES_DB" >/dev/null 2>&1
do
    sleep 1
done

set PGPASSWORD="$POSTGRES_PASSWORD"
until psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "SELECT COUNT(*) >= 16049 AS ready FROM payment;" | tail -n 1 | grep -q "t";
do
    {
        COUNTER=$(psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "SELECT COUNT(*) AS ready FROM payment;" | tail -n 3 | head -n 1 | xargs)
        echo "Current row count in payment table: $COUNTER"
        if [ -n "$COUNTER" ] && [ "$COUNTER" -eq 16049 ]; then
            echo "Data inserted into the database..."
            break
        fi
    } || {
        echo "query error, waiting for database to be ready..."
    }
    echo "Waiting for data to be inserted into the database..."
    sleep 1
done

kill "$pid"
wait "$pid"