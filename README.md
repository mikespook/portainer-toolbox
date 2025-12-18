# Portainer Toolbox

A collection of useful scripts and tools for managing Portainer deployments.

## Overview

This toolbox provides various utilities to help with:
- Backing up and restoring Portainer data
- Deployment automation
- Health monitoring
- Maintenance tasks

## Scripts

### Backup and Restore

- **`scripts/backup.sh`** - Backup Portainer data and configuration
- **`scripts/restore.sh`** - Restore Portainer from backup

### Deployment

- **`scripts/deploy.sh`** - Deploy or upgrade Portainer
- **`scripts/cleanup.sh`** - Clean up old Portainer resources

### Monitoring

- **`scripts/healthcheck.sh`** - Check Portainer health status
- **`scripts/logs.sh`** - View Portainer logs

## Usage

### Backup Portainer Data

```bash
./scripts/backup.sh [backup-directory]
```

### Deploy Portainer

```bash
./scripts/deploy.sh [version]
```

### Health Check

```bash
./scripts/healthcheck.sh [portainer-url]
```

## Requirements

- Docker
- Bash 4.0+
- curl (for health checks)

## Installation

1. Clone this repository:
```bash
git clone https://github.com/mikespook/portainer-toolbox.git
cd portainer-toolbox
```

2. Make scripts executable:
```bash
chmod +x scripts/*.sh
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

See [LICENSE](LICENSE) file for details.