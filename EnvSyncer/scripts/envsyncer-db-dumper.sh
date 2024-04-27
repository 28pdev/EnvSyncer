#!/bin/bash
# This script performs a database dump from a specified AWS environment.

# Retrieve database credentials and environment from command line arguments.
DB_USER=$1
DB_PASSWORD=$2
environment=${3-production}  # Default to 'production' if no environment is specified.
export AWS_PROFILE=myawsprofile_$environment  # Set the AWS CLI profile based on the specified environment.

# Set the port and database name based on the environment.
if [[ $environment == "staging" ]]; then
    localPortRDS="YourRdsLocalPort"  # Local port for the staging environment.
    DB_NAME="MyDB"       # Generic database name for the staging environment.
elif [[ $environment == "production" ]]; then
    localPortRDS="YourRdsLocalPort"  # Local port for the production environment.
    DB_NAME="MyDB"       # Generic database name for the production environment.
fi

# Announce the start of the database dump process.
echo "Performing database dump for $environment environment..."

# Perform the database dump without locking the tables, show progress with pv, and compress the output with gzip.
mysqldump -u $DB_USER -p$DB_PASSWORD --lock-tables=false -h localhost --port="$localPortRDS" $DB_NAME | pv -brtp | gzip > "MyDBDump-$environment.sql.gz"
# Check the exit status to determine if the dump was successful.
if [ "$?" -eq 0 ]
then
    echo "Mysqldump Success"
else
    echo "Mysqldump encountered a problem"
    exit 1
fi

# Confirm the completion of the dump and the location of the saved file.
echo "Database dump completed successfully and saved to MyDBDump-$environment.sql.gz"
