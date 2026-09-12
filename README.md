# Dockerized Web Server

A minimal Node.js web server, containerized with Docker, demonstrating
containerization basics, lifecycle management, health monitoring, and
deployment best practices.

## Project structure

```
docker-webserver-app/
├── server.js            # Node.js HTTP server (/ and /health routes)
├── public/index.html    # Static page served by the app
├── package.json
├── Dockerfile            # Image build instructions
├── docker-compose.yml    # Simplified lifecycle management
└── .dockerignore
```

## 1. Build the image

```bash
docker build -t docker-webserver-app .
```

## 2. Run the container

```bash
docker run -d -p 3000:3000 --name webserver-demo docker-webserver-app
```
Visit `http://localhost:3000`

Or with Compose (recommended — handles rebuild, restart policy, health check in one file):
```bash
docker compose up -d --build
```

## 3. Container lifecycle commands

| Action | Command |
|---|---|
| List running containers | `docker ps` |
| List all containers (incl. stopped) | `docker ps -a` |
| Stop the container | `docker stop webserver-demo` |
| Start it again | `docker start webserver-demo` |
| Restart | `docker restart webserver-demo` |
| Remove the container | `docker rm webserver-demo` |
| Remove the image | `docker rmi docker-webserver-app` |
| Stop + remove via Compose | `docker compose down` |

## 4. Monitor container health

The Dockerfile defines a `HEALTHCHECK` that pings `/health` every 30s.

```bash
docker ps                     # STATUS column shows (healthy) / (unhealthy)
docker inspect --format='{{json .State.Health}}' webserver-demo
```

## 5. View  / troubleshoot

```bash
docker logs webserver-demo          # view stdout/stderr
docker logs -f webserver-demo       # follow logs live
docker exec -it webserver-demo sh   # shell into the running container
docker stats webserver-demo         # live CPU/memory usage
```

**Common issues:**
- *Port already in use* → change the host port: `-p 3001:3000`
- *Container exits immediately* → check `docker logs webserver-demo` for the error
- *Health check failing* → exec into the container and manually `wget http://localhost:3000/health`

## 6. Best practices demonstrated

| Practice | Where |
|---|---|
| Small base image | `node:18-alpine` instead of full `node` |
| Layer caching | `package.json` copied and installed before source code |
| Non-root user | `USER appuser` in the Dockerfile |
| Health checks | `HEALTHCHECK` instruction + `/health` route |
| Graceful shutdown | `SIGTERM` handler in `server.js` |
| Restart policy | `restart: unless-stopped` in Compose |
| Minimal image context | `.dockerignore` excludes unnecessary files |
# Docker-webserver-app
