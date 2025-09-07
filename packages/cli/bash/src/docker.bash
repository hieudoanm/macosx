#!/bin/bash

### 🐳⚙️ Docker Shortcuts ⚙️🐳 ###

# 📦 List containers / images
alias dps='echo "📦🚢 Running containers:" && docker ps'
alias dpsa='echo "📦🧊 All containers (including stopped):" && docker ps -a'
alias dimg='echo "🖼️🐳 Docker images:" && docker images'

# 🧩 Docker Compose shortcut
alias dc='echo "🧩🐳 Docker Compose" && docker compose'

# 💀 Kill all running containers
alias dkillall='echo "💀🔥 Killing all running containers..." && docker kill $(docker ps -q) 2>/dev/null || echo "😴✨ No containers to kill."'

# 🧹 Remove all stopped containers
alias drmall='echo "🧹📦 Removing all containers..." && \
  CONTAINERS=$(docker ps -aq); \
  [ -n "$CONTAINERS" ] && docker rm -f $CONTAINERS || echo "😴✨ No containers to remove."'

# 🔥 Remove all Docker images
alias drmiall='echo "🔥🖼️ Removing all Docker images..." && \
  IMAGES=$(docker images -q); \
  [ -n "$IMAGES" ] && docker rmi -f $IMAGES || echo "😴✨ No images to remove."'

# 🛑 Stop all containers (safe)
alias dstopall='echo "🛑🚢 Stopping all running containers..." && docker stop $(docker ps -q) 2>/dev/null || echo "😴✨ No containers to stop."'

# 🧽 Remove dangling resources
alias dclean='echo "🧽🧼 Cleaning dangling Docker resources..." && docker system prune -f'

# 💣 Full cleanup: containers, images, networks, volumes, cache
alias dfullclean='echo "💣☢️ FULL Docker cleanup (containers, images, volumes, networks)..." && docker system prune -a --volumes -f'
