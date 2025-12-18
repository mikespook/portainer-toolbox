#!/bin/bash

# Portainer Restore Script
# This script restores Portainer data from a backup

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
BACKUP_FILE="$1"
PORTAINER_VOLUME="portainer_data"

echo -e "${GREEN}=== Portainer Restore Tool ===${NC}"
echo ""

# Check parameters
if [ -z "$BACKUP_FILE" ]; then
    echo -e "${RED}Error: Backup file not specified${NC}"
    echo "Usage: $0 <backup-file.tar.gz>"
    exit 1
fi

# Check if backup file exists
if [ ! -f "$BACKUP_FILE" ]; then
    echo -e "${RED}Error: Backup file '$BACKUP_FILE' not found${NC}"
    exit 1
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed${NC}"
    exit 1
fi

# Warning before restore
echo -e "${YELLOW}WARNING: This will overwrite existing Portainer data!${NC}"
echo "Backup file: $BACKUP_FILE"
echo "Target volume: $PORTAINER_VOLUME"
echo ""
read -p "Continue? (yes/no): " -r
echo

if [[ ! $REPLY =~ ^[Yy]es$ ]]; then
    echo "Restore cancelled"
    exit 0
fi

# Create volume if it doesn't exist
if ! docker volume inspect "$PORTAINER_VOLUME" &> /dev/null; then
    echo "Creating volume $PORTAINER_VOLUME..."
    docker volume create "$PORTAINER_VOLUME"
fi

# Get absolute path to backup file
BACKUP_FILE_ABS=$(realpath "$BACKUP_FILE")
BACKUP_DIR=$(dirname "$BACKUP_FILE_ABS")
BACKUP_NAME=$(basename "$BACKUP_FILE_ABS")

echo "Restoring Portainer data..."

# Restore using a temporary container
docker run --rm \
    -v "$PORTAINER_VOLUME":/data \
    -v "$BACKUP_DIR":/backup \
    alpine sh -c "cd /data && tar xzf /backup/$BACKUP_NAME"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Restore completed successfully${NC}"
    echo ""
    echo "Please restart Portainer to apply the restored data:"
    echo "  docker restart portainer"
else
    echo -e "${RED}✗ Restore failed${NC}"
    exit 1
fi
