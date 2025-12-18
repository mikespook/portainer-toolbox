#!/bin/bash

# Portainer Backup Script
# This script backs up Portainer data volume

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
BACKUP_DIR="${1:-./backups}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
PORTAINER_VOLUME="portainer_data"

echo -e "${GREEN}=== Portainer Backup Tool ===${NC}"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed${NC}"
    exit 1
fi

# Check if Portainer data volume exists
if ! docker volume inspect "$PORTAINER_VOLUME" &> /dev/null; then
    echo -e "${RED}Error: Portainer volume '$PORTAINER_VOLUME' not found${NC}"
    echo "Available volumes:"
    docker volume ls
    exit 1
fi

# Create backup directory
mkdir -p "$BACKUP_DIR"

BACKUP_FILE="$BACKUP_DIR/portainer_backup_${TIMESTAMP}.tar.gz"

echo "Backing up Portainer data volume..."
echo "Source: $PORTAINER_VOLUME"
echo "Destination: $BACKUP_FILE"
echo ""

# Create backup using a temporary container
if docker run --rm \
    -v "$PORTAINER_VOLUME":/data \
    -v "$(cd "$BACKUP_DIR" && pwd)":/backup \
    alpine tar czf "/backup/portainer_backup_${TIMESTAMP}.tar.gz" -C /data .; then
    BACKUP_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
    echo -e "${GREEN}✓ Backup completed successfully${NC}"
    echo "Backup file: $BACKUP_FILE"
    echo "Size: $BACKUP_SIZE"
else
    echo -e "${RED}✗ Backup failed${NC}"
    exit 1
fi

# List recent backups
echo ""
echo "Recent backups in $BACKUP_DIR:"
ls -lht "$BACKUP_DIR" | head -6
