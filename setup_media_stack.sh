#!/usr/bin/env bash
set -euo pipefail

echo "=========================================="
echo "  Media Stack Setup Script (Servarr Stack)"
echo "=========================================="

# Pre-flight Dependency Checks
MISSING_DEPS=()

if ! command -v docker >/dev/null 2>&1; then
    MISSING_DEPS+=("docker (Install via your package manager or official Docker repository)")
fi

if ! docker compose version >/dev/null 2>&1; then
    MISSING_DEPS+=("docker compose (Install docker-compose-plugin or docker-compose-v2)")
fi

if ! command -v curl >/dev/null 2>&1; then
    MISSING_DEPS+=("curl (Install via: sudo apt install curl)")
fi

if ! command -v sudo >/dev/null 2>&1; then
    MISSING_DEPS+=("sudo")
fi

if [ ${#MISSING_DEPS[@]} -ne 0 ]; then
    echo -e "\n[ERROR] Missing required dependencies:"
    for dep in "${MISSING_DEPS[@]}"; do
        echo "  - $dep"
    done
    echo -e "\nPlease install the missing tools above and re-run this script."
    exit 1
fi

echo "[INFO] All pre-flight dependency checks passed."

MEDIA_STACK_DIR="$HOME/docker/media-stack"
DATA_DIR="$HOME/data"

echo "[INFO] Initializing directory structures..."
mkdir -p "$MEDIA_STACK_DIR"/config/{prowlarr,sonarr,radarr,qbittorrent}
mkdir -p "$DATA_DIR"/downloads "$DATA_DIR"/media/{tv,movies}

echo "[INFO] Updating /etc/hosts for short domain aliases..."
DOMAINS=("prowlarr" "sonarr" "radarr" "qbit")
for domain in "${DOMAINS[@]}"; do
    if ! grep -q -w "$domain" /etc/hosts; then
        echo "127.0.0.1 $domain" | sudo tee -a /etc/hosts >/dev/null
        echo "  + Added 127.0.0.1 $domain"
    else
        echo "  . $domain alias already present"
    fi
done

echo "[INFO] Generating Caddyfile..."
cat << 'EOF' > "$MEDIA_STACK_DIR/Caddyfile"
http://prowlarr {
    reverse_proxy prowlarr:9696
}

http://sonarr {
    reverse_proxy sonarr:8989
}

http://radarr {
    reverse_proxy radarr:7878
}

http://qbit {
    reverse_proxy qbittorrent:8085
}
EOF

echo "[INFO] Generating docker-compose.yml..."
cat << 'EOF' > "$MEDIA_STACK_DIR/docker-compose.yml"
services:
  caddy:
    image: caddy:latest
    container_name: caddy
    ports:
      - "8888:80"
    volumes:
      - ./Caddyfile:/etc/caddy/Caddyfile
    restart: unless-stopped

  prowlarr:
    image: lscr.io/linuxserver/prowlarr:latest
    container_name: prowlarr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=auto
    volumes:
      - ./config/prowlarr:/config
    ports:
      - 9696:9696
    restart: unless-stopped

  sonarr:
    image: lscr.io/linuxserver/sonarr:latest
    container_name: sonarr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=auto
    volumes:
      - ./config/sonarr:/config
      - ~/data/media/tv:/tv
      - ~/data/downloads:/downloads
    ports:
      - 8989:8989
    restart: unless-stopped

  radarr:
    image: lscr.io/linuxserver/radarr:latest
    container_name: radarr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=auto
    volumes:
      - ./config/radarr:/config
      - ~/data/media/movies:/movies
      - ~/data/downloads:/downloads
    ports:
      - 7878:7878
    restart: unless-stopped

  qbittorrent:
    image: lscr.io/linuxserver/qbittorrent:latest
    container_name: qbittorrent
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=auto
      - WEBUI_PORT=8085
    volumes:
      - ./config/qbittorrent:/config
      - ~/data/downloads:/downloads
    ports:
      - 8085:8085
      - 6881:6881
      - 6881:6881/udp
    restart: unless-stopped
EOF

echo "[INFO] Deploying Docker containers..."
cd "$MEDIA_STACK_DIR"
docker compose up -d

echo -e "\n=========================================="
echo "  Setup Completed Successfully!"
echo "=========================================="
echo "Access your media stack services at:"
echo "  - Prowlarr:    http://prowlarr:8888"
echo "  - Sonarr:      http://sonarr:8888"
echo "  - Radarr:      http://radarr:8888"
echo "  - qBittorrent: http://qbit:8888"
echo "=========================================="
