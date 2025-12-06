#!/bin/bash

### Docker Shortcuts ###

# List containers / images
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dimg='docker images'

# Docker Compose shortcut
alias dc='docker compose'

# Kill all running containers
alias dkillall='docker kill $(docker ps -q) 2>/dev/null || echo "No containers to kill."'

# Remove all stopped containers
alias drmall='CONTAINERS=$(docker ps -aq); \
  [ -n "$CONTAINERS" ] && docker rm -f $CONTAINERS || echo "No containers to remove."'

# Remove all Docker images
alias drmiall='IMAGES=$(docker images -q); \
  [ -n "$IMAGES" ] && docker rmi -f $IMAGES || echo "No images to remove."'

# Stop all containers (safe version)
alias dstopall='docker stop $(docker ps -q) 2>/dev/null || echo "No containers to stop."'

# Remove dangling resources
alias dclean='docker system prune -f'

# Full cleanup: containers, images, networks, build cache
alias dfullclean='docker system prune -a --volumes -f'
