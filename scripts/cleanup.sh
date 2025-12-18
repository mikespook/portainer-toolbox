#!/bin/bash

# Portainer Cleanup Script
# This script removes Portainer and optionally its data

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
CONTAINER_NAME="portainer"
VOLUME_NAME="portainer_data"
REMOVE_DATA=false

echo -e "${GREEN}=== Portainer Cleanup Tool ===${NC}"
echo ""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --remove-data)
            REMOVE_DATA=true
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --remove-data    Also remove Portainer data volume"
            echo "  -h, --help       Show this help message"
            exit 0
            ;;
        *)
            echo -e "${RED}Error: Unknown option $1${NC}"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed${NC}"
    exit 1
fi

# Warning
echo -e "${YELLOW}WARNING: This will remove Portainer container${NC}"
if [ "$REMOVE_DATA" = true ]; then
    echo -e "${RED}WARNING: This will also remove all Portainer data!${NC}"
fi
echo ""
read -p "Continue? (yes/no): " -r
echo

if [[ ! $REPLY =~ ^[Yy]es$ ]]; then
    echo "Cleanup cancelled"
    exit 0
fi

# Stop and remove container
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "Stopping container..."
    docker stop "$CONTAINER_NAME" 2>/dev/null || true
    
    echo "Removing container..."
    docker rm "$CONTAINER_NAME"
    echo -e "${GREEN}✓ Container removed${NC}"
else
    echo "Container not found, skipping..."
fi

# Remove data volume if requested
if [ "$REMOVE_DATA" = true ]; then
    if docker volume inspect "$VOLUME_NAME" &> /dev/null; then
        echo "Removing data volume..."
        docker volume rm "$VOLUME_NAME"
        echo -e "${GREEN}✓ Data volume removed${NC}"
    else
        echo "Data volume not found, skipping..."
    fi
fi

echo ""
echo -e "${GREEN}Cleanup completed${NC}"
