#!/bin/bash

set -e;
/opt/mssql/bin/sqlservr > /tmp/mssql-init.log 2>&1 & pid=$!

export PATH=/opt/mssql-tools/bin:/opt/mssql-tools18/bin:$PATH

DBSTATUS=1
ERRCODE=1
i=0

while [[ $DBSTATUS -ne 0 ]] && [[ $i -lt 60 ]] && [[ $ERRCODE -ne 0 ]]; do
	i=$i+1
    {
        DBSTATUS=$(sqlcmd -h -1 -t 1 -U sa -P $MSSQL_SA_PASSWORD -N -C -Q "SET NOCOUNT ON; Select SUM(state) from sys.databases")
    } || {
        DBSTATUS=1
    }
	sleep 1
done

echo "SQL Server started"
sleep 2

echo "Creating schema..."
sqlcmd -h -1 -U sa -P $MSSQL_SA_PASSWORD  -N -C -i /01-schema.sql > /dev/null 2>&1
echo "Schema created"
sleep 2

echo "Inserting data into the database..."
sqlcmd -h -1 -U sa -P $MSSQL_SA_PASSWORD -d $MSSQL_DBNAME -N -C -i /02-data.sql > /dev/null 2>&1
echo "Data inserted";

kill "$pid"
wait "$pid"