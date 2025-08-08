# ReportPortal Docker Compose Deployment Guide

## 📋 Table of Contents
- [Overview](#overview)
- [Quick Start](#quick-start)
- [Understanding Docker Compose Structure](#understanding-docker-compose-structure)
- [Environment Variables & Anchors](#environment-variables--anchors)
- [Submodules Management](#submodules-management)
- [Development vs Production](#development-vs-production)
- [Advanced Configuration](#advanced-configuration)
- [Additional Resources](#additional-resources)
- [Contributing](#contributing)
- [License](#license)

## 🚀 Overview

ReportPortal is a comprehensive test automation reporting platform that consists of multiple microservices. This guide will help you understand and deploy ReportPortal using Docker Compose.

## ⚡ Quick Start

### Prerequisites
- Docker Engine 20.10+
- Docker Compose 2.0+
- Git
- At least 8GB RAM available

### Basic Deployment
```bash
# 1. Clone the repository
git clone https://github.com/reportportal/reportportal.git
cd reportportal

# 2. Start ReportPortal
docker-compose up -d

# 3. Access ReportPortal
# Open http://localhost:8080 in your browser
```

## 🏗️ Understanding Docker Compose Structure

### Service Profiles
ReportPortal uses Docker Compose profiles to control which services are launched:

```yaml
profiles:
  - core      # Essential services (UI, API, Database)
  - infra     # Infrastructure (Database, RabbitMQ, Gateway)
  - ""        # Default profile (Analyzers, optional services)
```

### Starting Different Profiles
```bash
# Start only core services
docker-compose --profile core up -d

# Start infrastructure + core
docker-compose --profile infra --profile core up -d

# Start everything (default)
docker-compose up -d
```

## 🔗 Environment Variables & Anchors

### Understanding Anchors (`&` and `*`)

Anchors are YAML features that allow you to reuse configuration blocks. In ReportPortal's docker-compose.yml:

```yaml
# Define an anchor (reusable configuration)
x-logging: &logging
  driver: "json-file"
  options:
    max-size: 100m
    max-file: "5"

# Use the anchor in services
services:
  api:
    logging:
      <<: *logging  # This copies all properties from the logging anchor
```

### Environment Variable Syntax

ReportPortal uses this pattern: `${VARIABLE_NAME-default_value}`

```yaml
# Example from docker-compose.yml
image: ${API_IMAGE-reportportal/service-api:5.14.2}
```

**How it works:**
- If `API_IMAGE` environment variable is set → use that value
- If `API_IMAGE` is not set → use the default value `reportportal/service-api:5.14.2`

### Setting Environment Variables

#### Method 1: .env File (Recommended)
Create a `.env` file in the project root:
```bash
# .env
API_IMAGE=reportportal/service-api:5.14.2
UI_IMAGE=reportportal/service-ui:5.14.3
POSTGRES_USER=rpuser
POSTGRES_PASSWORD=secure_password
POSTGRES_DB=reportportal
```

#### Method 2: Export Environment Variables
```bash
export API_IMAGE=reportportal/service-api:5.14.2
export UI_IMAGE=reportportal/service-ui:5.14.3
docker-compose up -d
```

#### Method 3: Inline with docker-compose
```bash
API_IMAGE=reportportal/service-api:5.14.2 docker-compose up -d
```

### Common Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `API_IMAGE` | `reportportal/service-api:5.14.2` | API service image |
| `UI_IMAGE` | `reportportal/service-ui:5.14.3` | UI service image |
| `UAT_IMAGE` | `reportportal/service-authorization:5.14.4` | Auth service image |
| `JOBS_IMAGE` | `reportportal/service-jobs:5.14.0` | Jobs service image |
| `MIGRATIONS_IMAGE` | `reportportal/migrations:5.14.1` | Database migrations |
| `ANALYZER_IMAGE` | `reportportal/service-auto-analyzer:5.14.2` | Analyzer service |
| `POSTGRES_USER` | `rpuser` | Database username |
| `POSTGRES_PASSWORD` | `rppass` | Database password |
| `POSTGRES_DB` | `reportportal` | Database name |

## 📦 Submodules Management

### What are Submodules?
Git submodules allow you to include other Git repositories within your main repository. ReportPortal uses submodules for individual service repositories. **Submodules are primarily used for development purposes.**

### Submodule Structure
```
reportportal/
├── service-api/          # API service (submodule)
├── service-ui/           # UI service (submodule)
├── service-authorization/ # Auth service (submodule)
├── service-jobs/         # Jobs service (submodule)
├── service-auto-analyzer/ # Analyzer service (submodule)
├── service-index/        # Index service (submodule)
└── migrations/           # Database migrations (submodule)
```

### Working with Submodules (Development Only)

#### Initial Setup for Development
```bash
# Clone with submodules (for development)
git clone --recursive https://github.com/reportportal/reportportal.git

# OR clone first, then initialize submodules
git clone https://github.com/reportportal/reportportal.git
cd reportportal
git submodule update --init --recursive
```

#### Updating Submodules
```bash
# Update all submodules to latest commits
git submodule update --remote

# Update specific submodule
git submodule update --remote service-api

# Commit the submodule updates
git add .
git commit -m "Update submodules to latest versions"
```

#### Building from Source vs Using Images

**Using Pre-built Images (Production Default):**
```yaml
services:
  api:
    image: ${API_IMAGE-reportportal/service-api:5.14.2}
    # build: ./service-api  # Commented out
```

**Building from Source (Development):**
```yaml
services:
  api:
    image: ${API_IMAGE-reportportal/service-api:5.14.2}
    build: ./service-api  # Uncomment to build from source
```

#### Development Workflow with Submodules
```bash
# 1. Make changes in a submodule
cd service-api
git checkout -b feature/new-feature
# ... make changes ...
git add .
git commit -m "Add new feature"
git push origin feature/new-feature

# 2. Update main repository to use your changes
cd ..
git add service-api
git commit -m "Update service-api to use new feature"

# 3. Build and test
docker-compose build api
docker-compose up -d api
```

## 🛠️ Development vs Production

### Development Environment

#### Local Development Setup
```bash
# 1. Create development environment file
cp .env.example .env.dev

# 2. Edit .env.dev for development
cat > .env.dev << EOF
# Development settings
RP_ENVIRONMENT=development
RP_DEBUG=true
RP_LOG_LEVEL=DEBUG

# Use local builds
API_IMAGE=reportportal/service-api:dev
UI_IMAGE=reportportal/service-ui:dev

# Development database
POSTGRES_USER=rpuser
POSTGRES_PASSWORD=dev_password
POSTGRES_DB=reportportal_dev
EOF

# 3. Start development environment
docker-compose --env-file .env.dev up -d
```

#### Development Docker Compose Override
Create `docker-compose.dev.yml`:
```yaml
version: '3.8'

services:
  api:
    build: ./service-api
    environment:
      - RP_DEBUG=true
      - RP_LOG_LEVEL=DEBUG
    volumes:
      - ./service-api:/app
      - /app/target  # Exclude build artifacts
    ports:
      - "8585:8585"  # Expose API directly

  ui:
    build: ./service-ui
    environment:
      - NODE_ENV=development
    volumes:
      - ./service-ui:/app
      - /app/node_modules
    ports:
      - "3000:3000"  # Expose UI directly

  postgres:
    ports:
      - "5432:5432"  # Expose database for local tools

  rabbitmq:
    ports:
      - "5672:5672"  # Expose AMQP
      - "15672:15672"  # Expose management UI

  opensearch:
    ports:
      - "9200:9200"  # Expose search API
```

#### Development Commands
```bash
# Start development environment
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d

# Rebuild specific service
docker-compose -f docker-compose.yml -f docker-compose.dev.yml build api

# View logs for development
docker-compose -f docker-compose.yml -f docker-compose.dev.yml logs -f api

# Run tests
docker-compose -f docker-compose.yml -f docker-compose.dev.yml run --rm api ./mvnw test
```

### Production Environment

```bash
# Start production environment
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d

# Start with monitoring
docker-compose -f docker-compose.yml -f docker-compose.prod.yml --profile monitoring up -d

# Scale services
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d --scale api=3

# Backup database
docker-compose -f docker-compose.yml -f docker-compose.prod.yml exec postgres pg_dump -U $POSTGRES_USER $POSTGRES_DB > backup.sql
```

## 🔧 Advanced Configuration

### Custom Service Configuration

#### Adding Custom Environment Variables
```yaml
services:
  api:
    environment:
      <<: *common-environment  # Include common variables
      # Add custom variables
      CUSTOM_SETTING: "value"
      RP_FEATURE_FLAG: "enabled"
```

#### Custom Volume Mounts
```yaml
services:
  api:
    volumes:
      - storage:/data/storage  # Named volume
```

**Important**: The `api`, `jobs`, and `uat` services must use the same volume to share data between services. This is required for proper functionality.

#### Custom Networks
```yaml
networks:
  reportportal:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/16
```

### Resource Limits

#### Setting Resource Limits
```yaml
services:
  api:
    deploy:
      resources:
        limits:
          memory: 2G
          cpus: '1.0'
        reservations:
          memory: 1G
          cpus: '0.5'
```

#### Memory and CPU Examples
```yaml
# Small service (512MB RAM, 0.25 CPU)
deploy:
  resources:
    limits:
      memory: 512M
      cpus: '0.25'

# Medium service (1GB RAM, 0.5 CPU)
deploy:
  resources:
    limits:
      memory: 1G
      cpus: '0.5'

# Large service (4GB RAM, 2 CPU)
deploy:
  resources:
    limits:
      memory: 4G
      cpus: '2.0'
```

## 📚 Additional Resources

### Official Documentation
- [ReportPortal Documentation](https://reportportal.io/docs)
- [Docker Compose Reference](https://docs.docker.com/compose/)

### Useful Commands Reference

#### Docker Compose Commands
```bash
# Start services
docker-compose up -d

# Stop services
docker-compose down

# Restart specific service
docker-compose restart api

# Rebuild and start
docker-compose up -d --build

# View resource usage
docker-compose top

# Execute command in running container
docker-compose exec api bash

# Copy files from/to container
docker-compose cp api:/app/logs/app.log ./logs/
```

#### Git Submodule Commands
```bash
# Initialize submodules
git submodule update --init --recursive

# Update submodules
git submodule update --remote

# Add new submodule
git submodule add https://github.com/reportportal/service-api.git service-api

# Remove submodule
git submodule deinit service-api
git rm service-api
```

### Environment Examples

#### Development Environment
```bash
# .env.dev
RP_ENVIRONMENT=development
RP_DEBUG=true
RP_LOG_LEVEL=DEBUG
API_IMAGE=reportportal/service-api:dev
UI_IMAGE=reportportal/service-ui:dev
POSTGRES_USER=rpuser
POSTGRES_PASSWORD=dev_pass
POSTGRES_DB=reportportal_dev
```

#### Production Environment
```bash
# .env.prod
RP_ENVIRONMENT=production
RP_DEBUG=false
RP_LOG_LEVEL=INFO
API_IMAGE=reportportal/service-api:5.14.2
UI_IMAGE=reportportal/service-ui:5.14.3
POSTGRES_USER=rp_prod_user
POSTGRES_PASSWORD=secure_production_password
POSTGRES_DB=reportportal_prod
RP_INITIAL_ADMIN_PASSWORD=secure_admin_password
```

---

## 🤝 Contributing

If you find issues or have suggestions for this guide, please:
1. Check existing issues
2. Create a new issue with detailed description
3. Submit a pull request with improvements

## 📄 License

This guide is part of the ReportPortal project and follows the same license terms.
