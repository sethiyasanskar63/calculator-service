# Calculator Microservice - Docker Setup

## Prerequisites

- Docker Desktop installed and running
- Java 21 (for local development)
- Maven 3.9+ (or use the included Maven wrapper)

## Docker Commands

### Build the Docker Image

**Step 1: Build the JAR file first (for faster Docker builds)**

```powershell
# Set JAVA_HOME
$env:JAVA_HOME = "C:\Program Files\Eclipse Adoptium\jdk-21.0.4.7-hotspot"

# Build the JAR
.\mvnw.cmd clean package -DskipTests
```

**Step 2: Build the Docker image (uses pre-built JAR - much faster!)**

```powershell
# Build the image (takes ~3-4 seconds!)
docker build -t calculator-service:latest .

# Build with a specific tag
docker build -t calculator-service:1.0.0 .
```

**Why this approach is better:**
- ⚡ **10x faster**: Build completes in ~3-4 seconds vs 30+ seconds
- 📦 **Smaller image**: ~328MB (JRE-only, no build tools)
- 🔄 **Better caching**: JAR is built locally, Docker only copies it
- 🛠️ **Easier debugging**: Build failures happen locally, not in Docker

### Run the Container

```powershell
# Run the container
docker run -d -p 8080:8080 --name calculator-service calculator-service:latest

# Run with environment variables
docker run -d -p 8080:8080 -e SPRING_PROFILES_ACTIVE=prod --name calculator-service calculator-service:latest
```

### Using Docker Compose

```powershell
# Start the service
docker-compose up -d

# View logs
docker-compose logs -f

# Stop the service
docker-compose down
```

### Container Management

```powershell
# View running containers
docker ps

# View logs
docker logs calculator-service

# Follow logs
docker logs -f calculator-service

# Stop the container
docker stop calculator-service

# Remove the container
docker rm calculator-service

# Remove the image
docker rmi calculator-service:latest
```

## Testing the Containerized Application

### Health Check
```powershell
curl http://localhost:8080/api/calculator/health
```

### Test Calculator Operations

**Addition:**
```powershell
Invoke-RestMethod -Uri http://localhost:8080/api/calculator/calculate `
  -Method POST `
  -Headers @{"Content-Type"="application/json"} `
  -Body '{"number1": 10, "number2": 5, "operation": "+"}'
```

**Subtraction:**
```powershell
Invoke-RestMethod -Uri http://localhost:8080/api/calculator/calculate `
  -Method POST `
  -Headers @{"Content-Type"="application/json"} `
  -Body '{"number1": 10, "number2": 5, "operation": "-"}'
```

**Multiplication:**
```powershell
Invoke-RestMethod -Uri http://localhost:8080/api/calculator/calculate `
  -Method POST `
  -Headers @{"Content-Type"="application/json"} `
  -Body '{"number1": 10, "number2": 5, "operation": "*"}'
```

**Division:**
```powershell
Invoke-RestMethod -Uri http://localhost:8080/api/calculator/calculate `
  -Method POST `
  -Headers @{"Content-Type"="application/json"} `
  -Body '{"number1": 10, "number2": 5, "operation": "/"}'
```

## Docker Image Details

- **Base Image**: eclipse-temurin:21-jre-alpine
- **Size**: ~328MB (JRE-only, no build tools)
- **Build Time**: ~3-4 seconds (using pre-built JAR)
- **Security**: Runs as non-root user (spring:spring)
- **JVM Optimization**: Configured for containerized environments
- **Approach**: Simple single-stage build using local JAR

## Build Strategy Benefits

1. **Fast Builds**: ~3-4 seconds (vs 30+ seconds for multi-stage)
2. **Better Caching**: Maven dependencies cached locally, not in Docker
3. **Smaller Image**: Only JRE and JAR file, no build tools
4. **Security**: Minimal attack surface with Alpine Linux + JRE
5. **Easier Debugging**: Build errors happen locally where you can fix them
6. **Production Ready**: Separate build and runtime concerns

## Environment Variables

You can configure the application using environment variables:

```powershell
docker run -d -p 8080:8080 \
  -e SPRING_PROFILES_ACTIVE=prod \
  -e SERVER_PORT=8080 \
  -e JAVA_OPTS="-Xmx512m -Xms256m" \
  --name calculator-service \
  calculator-service:latest
```

## Pushing to Container Registry

### Docker Hub
```powershell
# Tag the image
docker tag calculator-service:latest yourusername/calculator-service:latest

# Login to Docker Hub
docker login

# Push the image
docker push yourusername/calculator-service:latest
```

### Azure Container Registry
```powershell
# Login to ACR
az acr login --name yourregistry

# Tag the image
docker tag calculator-service:latest yourregistry.azurecr.io/calculator-service:latest

# Push the image
docker push yourregistry.azurecr.io/calculator-service:latest
```

## Troubleshooting

### Docker Desktop Not Running
If you see "pipe/dockerDesktopLinuxEngine" error:
1. Start Docker Desktop
2. Wait for it to fully initialize
3. Retry the docker command

### Port Already in Use
If port 8080 is already in use:
```powershell
# Use a different port
docker run -d -p 9090:8080 --name calculator-service calculator-service:latest
```

### View Container Logs
```powershell
docker logs calculator-service
```

### Interactive Shell Access
```powershell
docker exec -it calculator-service sh
```

## Next Steps

- Set up CI/CD pipeline for automated builds
- Deploy to Kubernetes
- Add monitoring and observability (Prometheus, Grafana)
- Implement distributed tracing
- Add API documentation (Swagger/OpenAPI)
