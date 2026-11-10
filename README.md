
# Jenkins + Docker + Nginx CI/CD Project

## Overview
Automated deployment of a static website using
Jenkins, GitHub, Docker, and Nginx.

## Technology Stack
- Ubuntu Server 24.04
- Jenkins
- Docker Engine
- Docker Compose
- Nginx
- Git and GitHub

## Architecture
GitHub → Jenkins → Docker Build → Nginx → Browser

## Pipeline Stages
1. Checkout source code
2. Validate project files
3. Build Docker image
4. Deploy using Docker Compose
5. Run HTTP smoke test

## Ports
- Jenkins: 8080
- Nginx Website: 8081

## Manual Deployment
```bash
docker compose up -d --build
```

## Verification
```bash
docker compose ps
curl http://localhost:8081
```

## Troubleshooting
```bash
docker ps -a
docker compose logs
docker stats
```

## Security
This is a single-server learning environment.
Production deployments require additional
access controls, secrets management, image
scanning, and rollback procedures.

## Author
Jignesh Patel
