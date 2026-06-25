# Day 5 - Docker Compose Project Verification Guide

## Project: Flask + Redis with Docker Compose

This guide verifies that:

* Flask application is running
* Redis is working
* Docker networking is configured correctly
* Docker volumes persist data
* Docker Compose orchestration works properly

---

# Step 1: Verify Project Structure

Your project directory should look like:

```text
devops-flask-app/
│
├── app.py
├── requirements.txt
├── Dockerfile
└── docker-compose.yml
```

Verify using:

```bash
ls
```

Expected output:

```text
app.py
Dockerfile
docker-compose.yml
requirements.txt
```

---

# Step 2: Build and Start Containers

From the project directory run:

```bash
docker compose up -d --build
```

### What Happens?

1. Builds Flask image from Dockerfile
2. Pulls Redis image
3. Creates Docker network
4. Creates Docker volume
5. Starts Redis container
6. Starts Flask container

Expected output:

```text
[+] Running 3/3
 ✔ Network created
 ✔ Container redis_cache started
 ✔ Container flask_web started
```

---

# Step 3: Verify Container Status

Check running containers:

```bash
docker compose ps
```

Expected:

```text
NAME          STATUS
flask_web     Up
redis_cache   Up
```

### If Any Container Shows "Exited"

Check logs immediately:

```bash
docker compose logs
```

---

# Step 4: Test Flask Application

Open browser:

```text
http://localhost:5000
```

Or use:

```bash
curl http://localhost:5000/
```

Expected response:

```json
{
  "message": "DevOps Project - Day 5: Flask + Redis",
  "version": "2.0",
  "visit_count": 1,
  "redis_host": "redis"
}
```

Run again:

```bash
curl http://localhost:5000/
```

Expected:

```json
{
  "visit_count": 2
}
```

Then:

```json
{
  "visit_count": 3
}
```

### Verification

This confirms:

* Flask is running
* Redis communication is working
* Counter is being stored in Redis

---

# Step 5: Test Health Endpoint

Run:

```bash
curl http://localhost:5000/health
```

Expected:

```json
{
  "status": "healthy",
  "redis": "connected"
}
```

### Verification

Confirms:

* Flask service is healthy
* Redis is reachable
* Docker networking is functioning correctly

---

# Step 6: Test Reset Endpoint

Reset the counter:

```bash
curl http://localhost:5000/reset
```

Expected:

```json
{
  "message": "Visit counter reset to 0"
}
```

Now check again:

```bash
curl http://localhost:5000/
```

Expected:

```json
{
  "visit_count": 1
}
```

---

# Step 7: Verify Redis Directly

Open Redis CLI:

```bash
docker compose exec redis redis-cli
```

Check counter:

```redis
GET visits
```

Expected:

```text
"1"
```

Increase visits through Flask:

```bash
curl http://localhost:5000/
```

Check again:

```redis
GET visits
```

Expected:

```text
"2"
```

### Verification

Confirms Redis is actually storing application data.

Exit Redis:

```redis
exit
```

---

# Step 8: Verify Environment Variables

Enter Flask container:

```bash
docker compose exec web sh
```

Check Redis host variable:

```bash
echo $REDIS_HOST
```

Expected:

```text
redis
```

### Verification

Confirms Docker Compose successfully injected environment variables.

Exit container:

```bash
exit
```

---

# Step 9: Verify Docker Network

List networks:

```bash
docker network ls
```

Expected to see something similar:

```text
devops-flask-app_app-network
```

Inspect network:

```bash
docker network inspect devops-flask-app_app-network
```

Look for:

```text
flask_web
redis_cache
```

### Verification

Both containers should be attached to the same network.

---

# Step 10: Verify Docker Volume

List volumes:

```bash
docker volume ls
```

Expected:

```text
devops-flask-app_redis-data
```

Inspect volume:

```bash
docker volume inspect devops-flask-app_redis-data
```

Docker should display the storage location.

### Verification

Confirms persistent storage exists.

---

# Step 11: Verify Data Persistence

Generate some visits:

```bash
curl http://localhost:5000/
curl http://localhost:5000/
curl http://localhost:5000/
```

Assume counter becomes:

```text
5
```

Stop containers:

```bash
docker compose down
```

Start again:

```bash
docker compose up -d
```

Check counter:

```bash
curl http://localhost:5000/
```

Expected:

```text
visit_count = 6
```

NOT:

```text
visit_count = 1
```

### Verification

Confirms Redis data survives container restarts because of Docker volumes.

---

# Step 12: View Application Logs

Show all logs:

```bash
docker compose logs
```

Show live Flask logs:

```bash
docker compose logs -f web
```

Open:

```text
http://localhost:5000
```

You should see requests appearing in real-time.

Press:

```bash
Ctrl + C
```

to stop log streaming.

---

# Success Criteria Checklist

Mark each item when completed:

* [ ] `docker compose up -d --build` works successfully
* [ ] `docker compose ps` shows both containers running
* [ ] `/` endpoint increments visit counter
* [ ] `/health` returns healthy status
* [ ] `/reset` resets counter
* [ ] Redis CLI shows updated visit count
* [ ] Environment variables are accessible
* [ ] Both containers are on the same Docker network
* [ ] Redis volume exists
* [ ] Counter survives container restart
* [ ] Application logs are visible

---

# Day 5 Completed 🎉

You have successfully verified:

* Dockerfile
* Flask Application
* Redis Integration
* Docker Networking
* Docker Volumes
* Docker Compose
* Container-to-Container Communication
* Persistent Storage

This concludes the Day 5 DevOps project validation.