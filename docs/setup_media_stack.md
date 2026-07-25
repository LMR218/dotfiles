# Media Stack Setup Script (`setup_media_stack.sh`)

Automates the deployment of a complete, unified media stack (Prowlarr, Sonarr, Radarr, qBittorrent) using Docker Compose and Caddy Reverse Proxy with short domain aliases on port 8888.

## Included Services
- **Prowlarr:** Indexer / Tracker manager (`http://prowlarr:8888`)
- **Sonarr:** TV show manager (`http://sonarr:8888`)
- **Radarr:** Movie manager (`http://radarr:8888`)
- **qBittorrent:** Torrent download client (`http://qbit:8888`)
- **Caddy:** Reverse proxy mapping short domain names to port 8888

## Prerequisites Check
The script strictly checks for the presence of:
- `docker`
- `docker compose`
- `curl`
- `sudo`

If any prerequisite is missing, the script displays installation instructions and exits with code 1 without automatically installing unrequested software.

## How to Run (Standalone)

```bash
curl -fsSL -O https://raw.githubusercontent.com/LMR218/dotfiles/main/setup_media_stack.sh && chmod +x setup_media_stack.sh && ./setup_media_stack.sh
```

## Directory Structure Created
```text
~/docker/media-stack/
├── Caddyfile
├── docker-compose.yml
└── config/
    ├── prowlarr/
    ├── sonarr/
    ├── radarr/
    └── qbittorrent/

~/data/
├── downloads/
└── media/
    ├── tv/
    └── movies/
```
