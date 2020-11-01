#!/bin/sh

set -e

# Perform all actions as $POSTGRES_USER
export PGUSER="$POSTGRES_USER"

# Create the 'template_aws_s3' template db
"${psql[@]}" <<- 'EOSQL'
CREATE DATABASE template_aws_s3 IS_TEMPLATE true;
EOSQL

# Load aws_s3 into both template_database and $POSTGRES_DB
for DB in template_aws_s3 "$POSTGRES_DB"; do
	echo "Loading aws_s3 extensions into $DB"
	"${psql[@]}" --dbname="$DB" <<-'EOSQL'
		CREATE EXTENSION IF NOT EXISTS plpythonu;
		CREATE EXTENSION IF NOT EXISTS aws_s3;
EOSQL
done
