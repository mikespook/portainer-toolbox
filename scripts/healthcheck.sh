#!/bin/bash

# Portainer Health Check Script
# This script checks the health status of Portainer

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
PORTAINER_URL="${1:-https://localhost:9443}"
CONTAINER_NAME="portainer"

echo -e "${GREEN}=== Portainer Health Check ===${NC}"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed${NC}"
    exit 1
fi

# Check if curl is installed
if ! command -v curl &> /dev/null; then
    echo -e "${YELLOW}Warning: curl is not installed, skipping HTTP checks${NC}"
    CURL_AVAILABLE=false
else
    CURL_AVAILABLE=true
fi

# Check container status
echo "Checking container status..."
if docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo -e "${GREEN}✓ Container is running${NC}"
    
    # Get container details
    docker ps --filter "name=^${CONTAINER_NAME}$" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    echo ""
    
    # Check container health
    HEALTH_STATUS=$(docker inspect --format='{{.State.Health.Status}}' "$CONTAINER_NAME" 2>/dev/null || echo "none")
    if [ "$HEALTH_STATUS" != "none" ]; then
        if [ "$HEALTH_STATUS" = "healthy" ]; then
            echo -e "${GREEN}✓ Health status: $HEALTH_STATUS${NC}"
        else
            echo -e "${YELLOW}⚠ Health status: $HEALTH_STATUS${NC}"
        fi
    fi
    
    # Check resource usage
    echo ""
    echo "Resource usage:"
    docker stats "$CONTAINER_NAME" --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}"
    
elif docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo -e "${YELLOW}⚠ Container exists but is not running${NC}"
    docker ps -a --filter "name=^${CONTAINER_NAME}$" --format "table {{.Names}}\t{{.Status}}"
    exit 1
else
    echo -e "${RED}✗ Container not found${NC}"
    exit 1
fi

# Check HTTP endpoint
if [ "$CURL_AVAILABLE" = true ]; then
    echo ""
    echo "Checking HTTP endpoint..."
    if curl -k -s -o /dev/null -w "%{http_code}" "$PORTAINER_URL/api/system/status" | grep -q "200\|401\|403"; then
        echo -e "${GREEN}✓ Portainer is responding at $PORTAINER_URL${NC}"
    else
        echo -e "${RED}✗ Portainer is not responding at $PORTAINER_URL${NC}"
        exit 1
    fi
fi

# Check logs for errors
echo ""
echo "Recent logs (last 10 lines):"
docker logs "$CONTAINER_NAME" --tail 10

echo ""
echo -e "${GREEN}Health check completed${NC}"
