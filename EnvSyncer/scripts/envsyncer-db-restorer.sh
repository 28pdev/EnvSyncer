#!/bin/bash

# Get AWS RDS backup credentials and environment from command line arguments.
AWS_RDS_BACKUP_USER=$1
AWS_RDS_BACKUP_PASSWORD=$2
environment=${3-staging}  # Default to 'staging' if no environment is specified.
export AWS_PROFILE=myawsprofile_$environment  # Set AWS CLI profile based on the specified environment.

# Determine the local port based on the environment.
if [[ $environment == "staging" ]]; then
    localPortRDS="9998"  # Local port for staging environment.
elif [[ $environment == "production" ]]; then
    localPortRDS="9994"  # Local port for production environment.
fi

# Change directory to where the dump file is located.
cd PATH/TO/YOUR/DUMPFILE

# Drop the existing database if it exists, and create a new one.
mysql -h localhost --port="$localPortRDS" -u $AWS_RDS_BACKUP_USER -p"$AWS_RDS_BACKUP_PASSWORD" -e "DROP DATABASE IF EXISTS MyDBDump"
mysql -h localhost --port="$localPortRDS" -u $AWS_RDS_BACKUP_USER -p"$AWS_RDS_BACKUP_PASSWORD" -e "CREATE DATABASE MyDBDump"
# Disable foreign key checks to avoid issues during data import.
mysql -h localhost --port="$localPortRDS" -u $AWS_RDS_BACKUP_USER -p"$AWS_RDS_BACKUP_PASSWORD" -e "SET FOREIGN_KEY_CHECKS=0"

# Import the data from the compressed SQL dump file.
gunzip < MyDBDump-$environment.sql.gz | mysql -h localhost --port="$localPortRDS" -u $AWS_RDS_BACKUP_USER -p"$AWS_RDS_BACKUP_PASSWORD" MyDBDump
# Check the exit status to determine if the import was successful.
if [ "$?" -eq 0 ]
then
    echo "Database restore successful."
else
    echo "Database restore encountered a problem"
    exit 1
fi
# Re-enable foreign key checks after the import.
mysql -h localhost --port="$localPortRDS" -u $AWS_RDS_BACKUP_USER -p"$AWS_RDS_BACKUP_PASSWORD" -e "SET FOREIGN_KEY_CHECKS=1"

# Confirm the completion of the database restore process.
echo "Database restore completed successfully."
