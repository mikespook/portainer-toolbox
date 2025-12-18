#!/bin/bash

# Portainer Deployment Script
# This script deploys or upgrades Portainer

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
VERSION="${1:-latest}"
PORTAINER_PORT="${PORTAINER_PORT:-9443}"
CONTAINER_NAME="portainer"
VOLUME_NAME="portainer_data"

echo -e "${GREEN}=== Portainer Deployment Tool ===${NC}"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed${NC}"
    exit 1
fi

# Check if Portainer is already running
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo -e "${YELLOW}Portainer container already exists${NC}"
    echo "Current status:"
    docker ps -a --filter "name=^${CONTAINER_NAME}$" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    echo ""
    read -p "Remove existing container and deploy fresh? (yes/no): " -r
    echo
    
    if [[ $REPLY =~ ^[Yy]es$ ]]; then
        echo "Stopping and removing existing container..."
        docker stop "$CONTAINER_NAME" 2>/dev/null || true
        docker rm "$CONTAINER_NAME" 2>/dev/null || true
    else
        echo "Deployment cancelled"
        exit 0
    fi
fi

# Create volume if it doesn't exist
if ! docker volume inspect "$VOLUME_NAME" &> /dev/null; then
    echo "Creating volume $VOLUME_NAME..."
    docker volume create "$VOLUME_NAME"
fi

echo "Deploying Portainer..."
echo "Version: $VERSION"
echo "Port: $PORTAINER_PORT"
echo ""

# Deploy Portainer
docker run -d \
    -p 8000:8000 \
    -p "$PORTAINER_PORT":9443 \
    --name="$CONTAINER_NAME" \
    --restart=always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v "$VOLUME_NAME":/data \
    portainer/portainer-ce:"$VERSION"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Portainer deployed successfully${NC}"
    echo ""
    echo "Access Portainer at: https://localhost:$PORTAINER_PORT"
    echo ""
    echo "Container status:"
    docker ps --filter "name=^${CONTAINER_NAME}$" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
else
    echo -e "${RED}✗ Deployment failed${NC}"
    exit 1
fi
