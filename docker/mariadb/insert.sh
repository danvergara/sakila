#!/bin/bash

set -e;
docker-entrypoint.sh mariadbd > /tmp/mysql-init.log 2>&1 & pid=$!

export MYSQL_ROOT_USER=root
export MYSQL_PWD="$MYSQL_ROOT_PASSWORD"

echo "Waiting for schema to be created..."
until mariadb -u "$MYSQL_ROOT_USER" -D "$MYSQL_DATABASE" < /01-schema.sql > /dev/null 2>&1
do
    sleep 1
done

echo "Schema created"
sleep 2

echo "Inserting data into the database..."
mariadb -u "$MYSQL_ROOT_USER" "$MYSQL_DATABASE" < /02-data.sql

echo "Data inserted";

kill "$pid"
wait "$pid"