#!/bin/bash

# load-docker-image.sh [-d] <HOST> <tar_file>
# Examples:
#   Local:  ./load-docker-image.sh myimage.tar
#   Remote: ./load-docker-image.sh ssh://192.168.1.10 myimage.tar
#   Remote with delete: ./load-docker-image.sh -d ssh://192.168.1.10 myimage.tar

set -euo pipefail

# Parse arguments
DELETE_AFTER_LOAD=false
while getopts "d" opt; do
  case $opt in
    d)
      DELETE_AFTER_LOAD=true
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

shift $((OPTIND-1))

if [[ $# -ne 1 && $# -ne 2 ]]; then
  echo "Usage: $0 [-d] [ssh://HOST] <docker_image.tar>"
  echo "  If HOST is omitted or doesn't start with ssh://, load image locally"
  echo "  If HOST starts with ssh://, load image remotely via SSH"
  exit 1
fi

# Check if first argument is an SSH URL
if [[ $# -eq 2 ]]; then
  REMOTE_HOST_OR_URL="$1"
  TAR_FILE="$2"
elif [[ $# -eq 1 ]]; then
  REMOTE_HOST_OR_URL=""
  TAR_FILE="$1"
else
  echo "Usage: $0 [-d] [ssh://HOST] <docker_image.tar>"
  exit 1
fi

# Validate local tar file
if [[ ! -f "$TAR_FILE" ]]; then
  echo "Error: Tar file not found: $TAR_FILE" >&2
  exit 1
fi

# Optional: Verify it's a regular file (not a directory)
if [[ ! -r "$TAR_FILE" ]]; then
  echo "Error: Tar file is not readable: $TAR_FILE" >&2
  exit 1
fi

# Check if it's a remote operation (starts with ssh://)
if [[ -n "$REMOTE_HOST_OR_URL" && "$REMOTE_HOST_OR_URL" =~ ^ssh://(.+) ]]; then
  # Extract hostname from URL
  REMOTE_HOST="${REMOTE_HOST_OR_URL#ssh://}"

  # Get basename to use on remote side
  REMOTE_TAR="$(basename -- "$TAR_FILE")"

  echo "[INFO] Uploading $TAR_FILE to $REMOTE_HOST..."
  scp "$TAR_FILE" "$REMOTE_HOST:/tmp/$REMOTE_TAR"

  echo "[INFO] Loading image into Docker on $REMOTE_HOST..."
  # Use 'bash -l' to ensure Docker is in PATH (in case non-login shell)
  if [[ "$DELETE_AFTER_LOAD" == true ]]; then
    ssh "$REMOTE_HOST" "bash -l -c 'docker load -i /tmp/$REMOTE_TAR && rm -f /tmp/$REMOTE_TAR'"
  else
    ssh "$REMOTE_HOST" "bash -l -c 'docker load -i /tmp/$REMOTE_TAR'"
  fi

  echo "[SUCCESS] Image loaded successfully on $REMOTE_HOST"
else
  # Local operation
  echo "[INFO] Loading image into local Docker..."
  docker load -i "$TAR_FILE"
  echo "[SUCCESS] Image loaded successfully locally"
fi