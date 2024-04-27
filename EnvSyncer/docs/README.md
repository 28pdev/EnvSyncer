# AWS Database Manager Script

This script is designed to manage database operations such as backups and restores for specific AWS environments. It supports operations in staging and production environments.

## Prerequisites

- AWS CLI installed and configured with the appropriate credentials.
- MySQL client installed on the system where the script will be executed.
- `pv` (Pipe Viewer) utility installed for monitoring the progress of database operations.
- Ensure you have the necessary permissions to execute database operations in your AWS environment.

## Installation

1. Clone the repository to your local machine:
   ```bash
   git clone https://github.com/peco3k/EnvSyncer.git

2. Navigate to the script directory:
   ```bash
   cd path/to/script

3. Ensure the script is executable:
    ```bash
   chmod +x aws-db-manager.sh

## Usage

The script can be executed with the following syntax:
    ```bash
./aws-db-manager.sh [action] [db-user] [db-password] [environment]

## Parameters:
- action: The operation to perform. Acceptable values are dump or restore.
- db-user: The database user name.
- db-password: The database user password.
- environment: Optional. The environment to target, defaults to staging if not specified. Acceptable values are staging or production.


## Examples

To perform a database dump:
    ```bash
./aws-db-manager.sh dump myuser mypassword staging

To restore a database:
    ```bash
./aws-db-manager.sh restore myuser mypassword productionwork

![EnvSyncerUseCase](https://github.com/peco3k/EnvSyncer/assets/94234460/c697e620-b9b6-4d94-bd10-a7c6af40b105)

## Troubleshooting

Ensure that the AWS CLI is configured correctly with aws configure.
Verify that the MySQL client tools are correctly installed and accessible in your system's PATH.
Check that the pv tool is installed for progress viewing functionality.

