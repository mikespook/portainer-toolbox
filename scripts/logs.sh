#!/bin/bash

# Portainer Logs Script
# This script displays Portainer logs

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
CONTAINER_NAME="portainer"
FOLLOW=false
TAIL_LINES=100

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -f|--follow)
            FOLLOW=true
            shift
            ;;
        -n|--lines)
            TAIL_LINES="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  -f, --follow       Follow log output"
            echo "  -n, --lines NUM    Number of lines to show (default: 100)"
            echo "  -h, --help         Show this help message"
            exit 0
            ;;
        *)
            echo -e "${RED}Error: Unknown option $1${NC}"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

echo -e "${GREEN}=== Portainer Logs ===${NC}"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed${NC}"
    exit 1
fi

# Check if container exists
if ! docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo -e "${RED}Error: Container '$CONTAINER_NAME' not found${NC}"
    exit 1
fi

# Show logs
if [ "$FOLLOW" = true ]; then
    echo "Following logs (Ctrl+C to stop)..."
    docker logs -f --tail "$TAIL_LINES" "$CONTAINER_NAME"
else
    docker logs --tail "$TAIL_LINES" "$CONTAINER_NAME"
fi
