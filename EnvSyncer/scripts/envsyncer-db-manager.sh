#!/bin/bash

# Define the operation to perform on the database ('dump' or 'restore') and user credentials.
ACTION=$1  # 'dump' or 'restore'
DB_USER=$2
DB_PASSWORD=$3
environment=${4-staging}  # Default environment is 'staging' if not specified
export AWS_PROFILE=myawsprofile_$environment  # Set AWS CLI profile based on the environment

# Set database connection details based on the environment
if [[ $environment == "staging" ]]; then
    localPortRDS="YourRdsLocalPort"  # Local port for database connection in staging
    DB_NAME="MyDB"       # Database name
elif [[ $environment == "production" ]]; then
    localPortRDS="YourRdsLocalPort"  # Local port for database connection in production
    DB_NAME="MyDB"       # Database name
fi

# Start the operation with an informative message
echo "Running database $ACTION for $environment environment..."

# Execute the appropriate action based on the specified ACTION
case $ACTION in
    dump)
        # Perform database dump without locking tables, show progress, and compress output
        mysqldump -u $DB_USER -p$DB_PASSWORD --lock-tables=false -h localhost --port="$localPortRDS" $DB_NAME | pv -brtp | gzip > "MyDBDump-$environment.sql.gz"
        # Check if the dump was successful
        if [ $? -eq 0 ]; then
            echo "Database dump successful."
        else
            echo "Database dump encountered a problem."
            exit 1
        fi
        ;;

    restore)
        # Change directory to the backup scripts location
        cd /home/ubuntu/actions-runner/_work/aws-scripts/aws-scripts/scripts/aws-db-backup
        # Drop existing database and create a new one for restore
        mysql -h localhost --port="$localPortRDS" -u $DB_USER -p"$DB_PASSWORD" -e "DROP DATABASE IF EXISTS MyDBDump"
        mysql -h localhost --port="$localPortRDS" -u $DB_USER -p"$DB_PASSWORD" -e "CREATE DATABASE MyDBDump"
        # Disable foreign key checks for the restore operation
        mysql -h localhost --port="$localPortRDS" -u $DB_USER -p"$DB_PASSWORD" -e "SET FOREIGN_KEY_CHECKS=0"
        # Decompress and import the database dump
        gunzip < MyDBDump-$environment.sql.gz | mysql -h localhost --port="$localPortRDS" -u $DB_USER -p"$DB_PASSWORD" MyDBDump
        # Check if the restore was successful
        if [ $? -eq 0 ]; then
            echo "Database restore successful."
        else
            echo "Database restore encountered a problem."
            exit 1
        fi
        # Re-enable foreign key checks after restore
        mysql -h localhost --port="$localPortRDS" -u $DB_USER -p"$DB_PASSWORD" -e "SET FOREIGN_KEY_CHECKS=1"
        ;;

    *)
        # Handle invalid action input
        echo "Invalid action specified. Use 'dump' or 'restore'."
        exit 1
        ;;
esac

# Final confirmation message
echo "Database $ACTION completed successfully."
