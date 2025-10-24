# 🚀 Quick Start: Deploying with CI/CD

## What You Have Now

✅ **Calculator Microservice** - Java 21 + Spring Boot 3.4.0
✅ **Swagger Documentation** - Interactive API docs
✅ **Docker Support** - Containerized application
✅ **GitHub Actions CI/CD** - Automated build and deployment

## 📝 To Enable CI/CD

### 1. Create Docker Hub Account (2 minutes)

```
1. Go to: https://hub.docker.com
2. Sign up (free)
3. Create Access Token:
   - Profile → Account Settings → Security
   - New Access Token → Name: "github-actions"
   - Copy the token
```

### 2. Push to GitHub (5 minutes)

```powershell
# Initialize git (if not done)
git init

# Make mvnw executable
git add mvnw
git update-index --chmod=+x mvnw

# Add all files
git add .

# Commit
git commit -m "Initial commit with CI/CD pipeline"

# Create repository on GitHub, then:
git remote add origin https://github.com/YOUR_USERNAME/calculator-service.git
git branch -M main
git push -u origin main
```

### 3. Add GitHub Secrets (2 minutes)

```
1. Go to: https://github.com/YOUR_USERNAME/calculator-service
2. Settings → Secrets and variables → Actions
3. New repository secret:
   
   Name:  DOCKERHUB_USERNAME
   Value: your-dockerhub-username
   
   Name:  DOCKERHUB_TOKEN
   Value: paste-your-token-here
```

### 4. Watch It Work! 🎉

```
1. Go to Actions tab in your GitHub repo
2. See your pipeline running
3. Wait ~3-5 minutes
4. Your Docker image will be at:
   docker pull YOUR_USERNAME/calculator-service:latest
```

## 🔄 What Happens Automatically

Every time you push code to `main`:

```
1. ✅ Code is checked out
2. ✅ Java 21 environment is set up
3. ✅ Application is built with Maven
4. ✅ All tests are run
5. ✅ Docker image is created
6. ✅ Image is pushed to Docker Hub
7. ✅ Dependencies are scanned for security issues
```

## 📊 Accessing Your Application

### Swagger UI (API Documentation)
```
http://localhost:8080/swagger-ui.html
```

### API Endpoints
```
Health Check: GET  http://localhost:8080/api/calculator/health
Calculate:    POST http://localhost:8080/api/calculator/calculate
```

### Example API Call
```powershell
Invoke-RestMethod -Uri http://localhost:8080/api/calculator/calculate `
  -Method POST `
  -Headers @{"Content-Type"="application/json"} `
  -Body '{"number1": 10, "number2": 5, "operation": "+"}'
```

## 🐳 Running from Docker Hub

After CI/CD completes:

```powershell
# Pull the latest image
docker pull YOUR_USERNAME/calculator-service:latest

# Run it
docker run -d -p 8080:8080 YOUR_USERNAME/calculator-service:latest

# Test it
curl http://localhost:8080/api/calculator/health
```

## 📁 Project Structure

```
calculator-service/
├── .github/
│   └── workflows/
│       └── ci-cd.yml          ← CI/CD pipeline configuration
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/calculator/
│   │   │       ├── config/
│   │   │       │   └── OpenAPIConfig.java    ← Swagger config
│   │   │       ├── controller/
│   │   │       ├── domain/
│   │   │       └── service/
│   │   └── resources/
│   │       └── application.properties        ← App configuration
│   └── test/
├── Dockerfile                  ← Docker image definition
├── docker-compose.yml          ← Local Docker setup
├── pom.xml                     ← Maven dependencies
└── CI-CD-SETUP.md             ← Detailed CI/CD guide
```

## 🎯 Next Steps

1. **Add Deployment Stage** - Deploy to Azure/AWS automatically
2. **Add Monitoring** - Prometheus + Grafana
3. **Add Database** - PostgreSQL integration
4. **Add Authentication** - JWT/OAuth2
5. **Add Rate Limiting** - Protect your API

## 📚 Documentation

- **Full CI/CD Setup Guide**: See `CI-CD-SETUP.md`
- **Docker Guide**: See `DOCKER.md`
- **Swagger UI**: Visit `/swagger-ui.html` when app is running

## 🆘 Need Help?

- **Build failing?** Check the Actions tab for detailed logs
- **Tests failing?** Run `./mvnw test` locally
- **Docker issues?** See `DOCKER.md`

---

**You're all set! Your microservice is production-ready with automated CI/CD.** 🚀
