# Media Stack Setup & Inter-App Linking Guide (`setup_media_stack.sh`)

Automates the deployment of a complete, unified media stack (Prowlarr, Sonarr, Radarr, qBittorrent, Bazarr) using Docker Compose and Caddy Reverse Proxy with short domain aliases on port 8888.

---

## 1. Quick Start One-Liner

```bash
curl -fsSL -O https://raw.githubusercontent.com/LMR218/dotfiles/main/setup_media_stack.sh && chmod +x setup_media_stack.sh && ./setup_media_stack.sh
```

---

## 2. Directory & Path Structure

### Host Paths
- **Stack & Configuration Root:** `~/docker/media-stack/`
  - `Caddyfile`
  - `docker-compose.yml`
  - `config/prowlarr/`
  - `config/sonarr/`
  - `config/radarr/`
  - `config/qbittorrent/`
  - `config/bazarr/`
- **Data & Media Root:** `~/data/`
  - `downloads/` (Raw qBittorrent download working folder)
  - `media/tv/` (Organized TV Show library)
  - `media/movies/` (Organized Movie library)

### Docker Internal Volume Mappings
- **Sonarr:** `/tv` -> `~/data/media/tv`, `/downloads` -> `~/data/downloads`
- **Radarr:** `/movies` -> `~/data/media/movies`, `/downloads` -> `~/data/downloads`
- **qBittorrent:** `/downloads` -> `~/data/downloads`
- **Bazarr:** `/tv` -> `~/data/media/tv`, `/movies` -> `~/data/media/movies`

---

## 3. Dedicated Application Breakdown & URLs

All services are accessible on universal proxy port **`8888`** using short local domains:

### 3.1 Prowlarr — Tracker / Indexer Manager
- **URL:** `http://prowlarr:8888` (or `http://localhost:9696`)
- **Role:** Manages public/private torrent trackers in one place and syncs them automatically to Sonarr and Radarr.
- **Initial Configuration:**
  1. Go to **Indexers** -> **+ Add Indexer** -> Add trackers (e.g. `1337x`, `YTS`, `EZTV`, `ArabP2P`, `TorrentGalaxy`).
  2. Go to **Settings** -> **Apps** -> **+** -> Add **Sonarr** and **Radarr**.

### 3.2 Sonarr — TV Series Manager
- **URL:** `http://sonarr:8888` (or `http://localhost:8989`)
- **Role:** Automates TV show tracking, downloads new episodes as they air, and organizes files cleanly.
- **Root Folder:** `/tv` (maps to `~/data/media/tv/`).
- **Initial Configuration:**
  1. Go to **Settings** -> **Download Clients** -> **+** -> Select **qBittorrent**.

### 3.3 Radarr — Movie Manager
- **URL:** `http://radarr:8888` (or `http://localhost:7878`)
- **Role:** Automates movie tracking, searches for best quality releases, and organizes files.
- **Root Folder:** `/movies` (maps to `~/data/media/movies/`).
- **Initial Configuration:**
  1. Go to **Settings** -> **Download Clients** -> **+** -> Select **qBittorrent**.

### 3.4 qBittorrent — Torrent Download Client
- **URL:** `http://qbit:8888` (or `http://localhost:8085`)
- **Role:** Handles active torrent downloading into `~/data/downloads/`.
- **First-Time Login:**
  - **Username:** `admin`
  - **Temporary Password:** Retrieve using: `docker logs qbittorrent 2>&1 | grep -i "password"`
  - **Permanent Password:** Go to **Tools ⚙️** -> **Web UI** -> **Authentication** -> Set username & password -> **Save**.

### 3.5 Bazarr — Subtitle Manager (Arabic & English)
- **URL:** `http://bazarr:8888` (or `http://localhost:6767`)
- **Role:** Automatically downloads Arabic and English subtitles for movies and shows.
- **Initial Configuration:**
  1. Go to **Settings** -> **Languages** -> Add **Arabic** and **English** (Profile: `Normal or hearing-impaired`, Search: `Always`).
  2. Go to **Settings** -> **Providers** -> Add `OpenSubtitles`, `Subscene`, or `Podnapisi`.
  3. Go to **Settings** -> **Sonarr / Radarr** -> Enable and connect.

---

## 4. Inter-App Connection Guide (Docker Network)

Because all apps run in the same Docker Compose network, **use container names instead of `localhost`** when linking them:

| Linking From | Connecting To | Host Field | Port Field | Full Connection URL |
|---|---|---|---|---|
| **Prowlarr** | **Sonarr** | `sonarr` | `8989` | `http://sonarr:8989` |
| **Prowlarr** | **Prowlarr (self)** | `prowlarr` | `9696` | `http://prowlarr:9696` |
| **Prowlarr** | **Radarr** | `radarr` | `7878` | `http://radarr:7878` |
| **Sonarr** | **qBittorrent** | `qbittorrent` | `8085` | `http://qbittorrent:8085` |
| **Radarr** | **qBittorrent** | `qbittorrent` | `8085` | `http://qbittorrent:8085` |
| **Bazarr** | **Sonarr** | `sonarr` | `8989` | `http://sonarr:8989` |
| **Bazarr** | **Radarr** | `radarr` | `7878` | `http://radarr:7878` |

---

## 5. Deletion & Hardlink Rules

- **Hardlinks:** Files in `~/data/downloads/` and `~/data/media/` share physical storage blocks via hardlinks on Ext4. They do **NOT** take double disk space.
- **Best Practice for Deleting:** Always delete movies or TV shows from inside **Radarr** or **Sonarr** (check the *"Delete files"* box). They will automatically remove both the library file and the torrent file from qBittorrent.
