# Day 3 — Docker Fundamentals

> **30-Day DevOps Plan | Week 1 — Linux + Git + Docker**

---

## Core Concept — Container vs VM

| | **VM** | **Container** |
|---|---|---|
| Includes | Full OS + kernel | Just app + dependencies |
| Size | GBs | MBs |
| Startup | Minutes | Seconds |
| Isolation | Hardware-level | Process-level |

Containers share the host kernel — that's why they're lightweight. Docker packages your app with everything it needs to run, nothing more.

---

## Topics Covered

### 1. Install Docker Desktop
- Download from [docker.com](https://docker.com) for your OS
- Verify installation:
```bash
docker --version
docker info
```

---

### 2. Key Commands — Learn These Cold

```bash
docker pull nginx                            # download image from Docker Hub
docker run -d -p 8080:80 --name my-nginx nginx  # run a container
docker ps                                    # list running containers
docker ps -a                                 # all containers (including stopped)
docker stop my-nginx                         # stop a container
docker rm my-nginx                           # remove a container
docker logs my-nginx                         # view stdout logs
docker exec -it my-nginx bash               # shell into a running container
```

---

### 3. Port Mapping — Important Mental Model

```
-p 8080:80  →  host:container
```

Your machine's port `8080` maps to the container's port `80`.  
The container has its own network namespace — it doesn't know about your host ports unless you map them.

#### Why You Can't Reach Your Container — The Golden Rule

> **Containers are islands. `-p` is the bridge.**

| Ran with | Result |
|---|---|
| `-p 8080:80` | Accessible at localhost:8080 ✅ |
| No `-p` flag | Container runs but unreachable from browser ❌ |
| `--name my-nginx` | You chose the name |
| No `--name` | Docker auto-generates a random name (e.g. `hopeful_mestorf`) |

#### Port Mapping Examples
```bash
-p 8080:80      # browser hits 8080, nginx gets 80
-p 3000:80      # browser hits 3000, nginx gets 80
-p 9999:5000    # browser hits 9999, Flask gets 5000
```

---

### 4. Understanding `docker exec -it`

```
docker exec -it my-nginx bash
│      │    │   │        │
│      │    │   │        └── Command to run inside the container
│      │    │   └─────────── Which container to enter
│      │    └─────────────── Flags (-i and -t combined)
│      └──────────────────── Execute a command in a running container
└─────────────────────────── Docker CLI
```

| Flag | Meaning |
|---|---|
| `-i` | Keeps STDIN open — your keyboard input goes into the container |
| `-t` | Allocates a pseudo terminal — gives you a proper shell experience |
| `-it` | Together = feels like a normal terminal session |

> **Important:** Changes made inside `exec` are temporary. When the container is removed, everything inside is gone. Persistent changes go in the **Dockerfile** (Day 4).

---

### 5. Reading `docker ps` Output

```
CONTAINER ID    IMAGE    STATUS           PORTS                    NAMES
97235319cc8f    nginx    Up 27 seconds    0.0.0.0:8080->80/tcp     my-nginx
5eda25bd5a83    nginx    Up 2 minutes     80/tcp                   hopeful_mestorf
```

| Column | Meaning |
|---|---|
| CONTAINER ID | Unique short ID — use in commands like `docker stop 9723...` |
| IMAGE | The image it was built from |
| STATUS | `Up X seconds` = healthy and running |
| PORTS | Port mapping between host and container |
| NAMES | Human-readable name |

---

### 6. Image Layers

```bash
docker images               # list local images
docker image inspect nginx  # see layer details
docker rmi nginx            # remove an image
```

Every `RUN`, `COPY`, `ADD` in a Dockerfile creates a new layer. Layers are cached — this becomes very important in Day 4.

---

### 7. Docker Hub

- Public registry at [hub.docker.com](https://hub.docker.com)
- `docker pull python:3.11-slim` — the `slim` tag means minimal base, always prefer it for production
- When Docker can't find an image locally, it automatically pulls from Docker Hub

---

## Debugging — "Why Can't I Reach My Container?" Checklist

```bash
# 1. Is it actually running?
docker ps

# 2. Does it have a port mapping? (check PORTS column)
docker ps

# 3. What exact port mapping?
docker inspect my-nginx | grep -A 10 "Ports"

# 4. Is something else using that host port?
netstat -tulpn | grep 8080      # Linux/WSL
netstat -ano | findstr 8080     # Windows PowerShell

# 5. Is the app actually listening inside the container?
docker exec -it my-nginx bash
curl localhost:80               # test from inside the container itself
```

---

## Cleanup Commands

```bash
# Stop all running containers
docker stop $(docker ps -q)

# Remove all stopped containers
docker container prune

# Remove unused images (frees disk space)
docker image prune -a

# See how much disk Docker is using
docker system df

# Nuclear option — clean everything
docker system prune
```

---

## 📦 Day 3 Project

Run through this full sequence:

```bash
# Step 1 — Pull and run nginx
docker run -d -p 8080:80 --name my-nginx nginx

# Step 2 — Verify (open localhost:8080 in browser)
docker ps

# Step 3 — Shell into it and explore
docker exec -it my-nginx bash

# Inside the container:
ls /etc/nginx/
cat /etc/nginx/nginx.conf
curl localhost:80
exit

# Step 4 — Check logs
docker logs my-nginx

# Step 5 — Clean up
docker stop my-nginx && docker rm my-nginx

# Step 6 — Confirm clean
docker ps -a
```

---

## Key Mental Models for Interviews

| Concept | Mental Model |
|---|---|
| Image vs Container | Image is a blueprint, container is an instance |
| Port mapping | Containers are islands, `-p` is the bridge |
| Ephemeral containers | Anything written inside is lost when container is removed |
| `-it` flag | Interactive terminal — use when you want a shell session inside |
| `exec` vs `run` | `exec` enters running container, `run` creates a new one |

---

## exec vs run — The Key Difference

| | `docker exec` | `docker run` |
|---|---|---|
| Container state | Must already be running | Creates a brand new one |
| Use case | Debugging, inspecting | Starting fresh containers |
| Example | `docker exec -it my-nginx bash` | `docker run -it nginx bash` |

---

## What's Next — Day 4

You will create 3 files and build your own Docker image:

```
day4/
├── app.py            ← your Flask web app
├── requirements.txt  ← Python dependencies
└── Dockerfile        ← instructions to containerize it
```

This Flask app becomes your portfolio project that carries through the entire 30 days.

---

> **Remember:** Every command learned today with nginx — you'll use daily for the rest of the 30 days on your own app. nginx was just the training wheels.
