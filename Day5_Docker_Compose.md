# Day 5: Docker Compose — Multi-Container Applications

## Overview
Docker Compose is a tool for defining and running **multi-container Docker applications** using a single YAML file (`docker-compose.yml`). Instead of running `docker run` commands manually for each container, Compose lets you declare all services, networks, and volumes in one place.

---

## Core Concepts Learned

### 1. `docker-compose.yml` Structure

```yaml
version: '3.9'

services:       # ← Containers (web, redis, db, etc.)
  service_name:
    image: ...        # Pre-built image  OR
    build: .          # Build from Dockerfile
    ports: [...]      # Port mapping
    environment: [...] # Env variables
    depends_on: [...] # Service startup order
    volumes: [...]    # Mount paths or named volumes
    networks: [...]   # Custom network membership
    restart: ...      # Restart policy

volumes:        # ← Named volumes for data persistence
  my-volume:

networks:       # ← Custom isolated networks
  my-network:
    driver: bridge
```

---

### 2. Multi-Container App: Flask + Redis

The Day 5 project upgrades the Flask app to use Redis as a **visit counter** — a classic stateful multi-service pattern.

**How it works:**
- Every `GET /` request increments a counter in Redis
- Redis stores the count persistently using a Docker volume
- Flask connects to Redis via the **service name** (`redis`) as the hostname — Docker Compose DNS handles this automatically

```
Browser → Flask (web:5000) → Redis (redis:6379)
                              ↕
                        redis-data volume
```

---

### 3. Key Commands

| Command | Description |
|---|---|
| `docker compose up` | Start all services (foreground) |
| `docker compose up -d` | Start all services in **detached** (background) mode |
| `docker compose up --build` | Rebuild images before starting |
| `docker compose down` | Stop and remove containers + networks |
| `docker compose down -v` | Also remove named volumes |
| `docker compose logs` | View logs from all services |
| `docker compose logs web` | Logs from a specific service |
| `docker compose logs -f` | Follow (stream) logs in real time |
| `docker compose ps` | List running services and their status |
| `docker compose exec web bash` | Open a shell inside the web container |
| `docker compose restart web` | Restart a single service |

---

### 4. `depends_on` — Service Start Order

```yaml
services:
  web:
    depends_on:
      - redis   # Docker starts redis BEFORE web
```

> ⚠️ **Important:** `depends_on` only waits for the container to **start**, not for the service inside to be **ready**. For production, use healthchecks or a wait script to ensure Redis is fully accepting connections before Flask tries to connect.

---

### 5. Environment Variables in Compose

**Method 1 — Inline list:**
```yaml
environment:
  - REDIS_HOST=redis
  - FLASK_ENV=development
```

**Method 2 — Map syntax:**
```yaml
environment:
  REDIS_HOST: redis
  FLASK_ENV: development
```

**Method 3 — `.env` file (best for secrets):**
```yaml
env_file:
  - .env
```
`.env`:
```
REDIS_HOST=redis
SECRET_KEY=supersecretkey
```

---

### 6. Networking in Compose

When you define a custom network, all services on that network can reach each other using the **service name** as a hostname:

```yaml
networks:
  app-network:
    driver: bridge
```

Inside `app.py`:
```python
redis_host = os.environ.get('REDIS_HOST', 'localhost')  # → "redis"
redis_client = redis.Redis(host=redis_host, port=6379)
```

Flask doesn't need to know the IP — Docker's internal DNS resolves `redis` → container IP automatically.

---

### 7. Volumes in Compose

```yaml
volumes:
  redis-data:     # Named volume
    driver: local
```

```yaml
services:
  redis:
    volumes:
      - redis-data:/data   # Mount the named volume to /data in the container
```

| Volume Type | Example | Use Case |
|---|---|---|
| Named volume | `redis-data:/data` | Persist DB data across restarts |
| Bind mount | `./code:/app` | Live reload for development |
| Anonymous | `/tmp` | Temporary scratch space |

---

## Project Files

### `app.py` (Updated — Flask + Redis)
- Connects to Redis via `REDIS_HOST` env var
- `GET /` → increments and returns visit counter
- `GET /health` → returns app + Redis connection status
- `GET /reset` → resets the visit counter to 0

### `requirements.txt`
```
Flask==3.0.3
redis==5.0.4
```

### `docker-compose.yml`
```yaml
version: '3.9'

services:
  web:
    build: .
    container_name: flask_web
    ports:
      - "5000:5000"
    environment:
      - REDIS_HOST=redis
      - FLASK_ENV=development
    depends_on:
      - redis
    networks:
      - app-network
    restart: on-failure

  redis:
    image: redis:alpine
    container_name: redis_cache
    ports:
      - "6379:6379"
    volumes:
      - redis-data:/data
    networks:
      - app-network
    restart: always

volumes:
  redis-data:
    driver: local

networks:
  app-network:
    driver: bridge
```

---

## Commands Executed

```bash
# Step into the project folder
cd devops-flask-app

# Build and start all services in detached mode
docker compose up -d --build

# Check running services
docker compose ps

# Test the endpoints
curl http://localhost:5000/           # Visit counter (increments each call)
curl http://localhost:5000/health     # Health check (shows Redis status)
curl http://localhost:5000/reset      # Reset visit counter

# View logs from all services
docker compose logs

# Stream logs from web service only
docker compose logs -f web

# Stop and clean up (keep volumes)
docker compose down

# Stop and clean up (delete volumes too)
docker compose down -v
```

---

## Key Takeaways

| Concept | Insight |
|---|---|
| **Service Discovery** | Compose auto-creates DNS — use service names as hostnames (e.g., `redis` instead of IP) |
| **Volumes** | Named volumes persist data across `docker compose down`. Use `-v` to wipe them |
| **`depends_on`** | Controls start order, NOT readiness. Add health checks for production |
| **Env Vars** | Pass config between containers without hardcoding. Use `.env` files for secrets |
| **Networks** | Services on the same network are isolated from the outside but can talk to each other |
| **Single Command** | `docker compose up -d --build` replaces many separate `docker run` commands |
