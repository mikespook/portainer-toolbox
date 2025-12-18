# Basic Usage Examples

This document provides basic usage examples for the Portainer Toolbox scripts.

## Deploying Portainer

Deploy the latest version of Portainer:

```bash
./scripts/deploy.sh
```

Deploy a specific version:

```bash
./scripts/deploy.sh 2.19.0
```

Deploy on a custom port (using environment variable):

```bash
PORTAINER_PORT=9000 ./scripts/deploy.sh
```

## Backing Up Portainer Data

Create a backup in the default location (./backups):

```bash
./scripts/backup.sh
```

Create a backup in a custom directory:

```bash
./scripts/backup.sh /path/to/backup/directory
```

## Restoring Portainer Data

Restore from a backup file:

```bash
./scripts/restore.sh /path/to/backup/portainer_backup_20231218_120000.tar.gz
```

## Monitoring Portainer

Check Portainer health:

```bash
./scripts/healthcheck.sh
```

Check health of a remote Portainer instance:

```bash
./scripts/healthcheck.sh https://portainer.example.com:9443
```

View logs:

```bash
# Show last 100 lines (default)
./scripts/logs.sh

# Show last 50 lines
./scripts/logs.sh -n 50

# Follow logs in real-time
./scripts/logs.sh -f
```

## Cleanup

Remove Portainer container (keeps data):

```bash
./scripts/cleanup.sh
```

Remove Portainer container and all data:

```bash
./scripts/cleanup.sh --remove-data
```

## Complete Workflow Example

Here's a complete workflow for upgrading Portainer:

```bash
# 1. Create a backup
./scripts/backup.sh

# 2. Check current health
./scripts/healthcheck.sh

# 3. Deploy new version (this will prompt to remove existing container)
./scripts/deploy.sh 2.19.0

# 4. Verify the new deployment
./scripts/healthcheck.sh

# 5. Check logs for any issues
./scripts/logs.sh -n 50
```

## Automation Example

You can create a cron job for automated backups:

```bash
# Edit crontab
crontab -e

# Add this line for daily backups at 2 AM
0 2 * * * /path/to/portainer-toolbox/scripts/backup.sh /path/to/backups
```
