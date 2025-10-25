# 🧮 Calculator Microservice# Calculator Microservice



A production-ready Spring Boot microservice demonstrating modern cloud-native development with **Kubernetes on Oracle Cloud**.A production-ready Spring Boot microservice for basic arithmetic operations.



[![CI/CD - Oracle Cloud](https://github.com/sethiyasanskar63/calculator-service/actions/workflows/oci-deploy.yml/badge.svg)](https://github.com/sethiyasanskar63/calculator-service/actions/workflows/oci-deploy.yml)## 🎯 Learning Journey

[![Java](https://img.shields.io/badge/Java-21-orange.svg)](https://openjdk.java.net/)

[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.4.0-brightgreen.svg)](https://spring.io/projects/spring-boot)This project is part of a **6-phase microservices learning journey**:

[![Kubernetes](https://img.shields.io/badge/Kubernetes-1.34-blue.svg)](https://kubernetes.io/)

- ✅ **Phase 1:** Docker & Containerization

---- 🚀 **Phase 2:** Kubernetes (IN PROGRESS)

- ⏸️ **Phase 3:** Second Microservice

## 🚀 Quick Start- ⏸️ **Phase 4:** Spring Cloud Gateway

- ⏸️ **Phase 5:** Service Discovery

### Local Development- ⏸️ **Phase 6:** Monitoring & Tracing

```bash

# Build and run📖 **See:** `PROGRESS.md` for detailed tracking  

./mvnw spring-boot:run📚 **Current:** `PHASE2-KUBERNETES-TUTORIAL.md`



# Access Swagger UI---

open http://localhost:8080/swagger-ui/index.html

```## 🌐 Live Demo



### Kubernetes (Minikube)- **API**: https://calculator-service-production.up.railway.app

```bash- **Swagger UI**: https://calculator-service-production.up.railway.app/swagger-ui.html

# Start Minikube

minikube start---



# Deploy## 🛠️ Tech Stack

kubectl apply -f config/k8s/

```- **Java 21** (Eclipse Temurin)

- **Spring Boot 3.4.0**

### Oracle Cloud Production- **Maven** (build tool)

```bash- **Docker** (containerization)

# Automatic deployment via GitHub Actions on push to main- **Kubernetes** (orchestration) 🆕

git push origin main- **Railway** (hosting)

```- **GitHub Actions** (CI/CD)



------



## 📦 What's Inside## 📡 API Usage



### Core Technologies### Health Check

- **Java 21** - Latest LTS version```bash

- **Spring Boot 3.4.0** - Modern Java frameworkcurl https://calculator-service-production.up.railway.app/api/calculator/health

- **Maven** - Dependency management```

- **Docker** - Containerization

- **Kubernetes** - Orchestration### Calculate

```bash

### Featurescurl -X POST https://calculator-service-production.up.railway.app/api/calculator/calculate \

- ✅ RESTful API with OpenAPI/Swagger documentation  -H "Content-Type: application/json" \

- ✅ Comprehensive test coverage (JaCoCo)  -d "{

- ✅ Health checks (Spring Boot Actuator)    \"number1\": 10,

- ✅ Production-ready Docker images    \"number2\": 5,

- ✅ Kubernetes manifests for cloud deployment    \"operation\": \"+\"

- ✅ CI/CD pipeline with GitHub Actions  }"

- ✅ Automated deployment to Oracle Cloud (OKE)```



---**Operations**: `+`, `-`, `*`, `/`



## 🏗️ Architecture---



### Local Development## 💻 Local Development

```

Developer → IDE → Maven → Spring Boot (Port 8080)### Prerequisites

```- Java 21

- Maven 3.8+

### Kubernetes (Oracle Cloud)

```### Run Locally

GitHub Push```bash

    ↓# Build

GitHub Actions./mvnw clean package

    ↓

├─ Build & Test# Run

├─ Docker Image → OCI Registry./mvnw spring-boot:run

└─ Deploy → OKE Cluster

         ↓# Test

    LoadBalancer (Public IP)./mvnw test

         ↓```

    3 Pods (Auto-scaled)

```Application runs at: `http://localhost:8080`



------



## 📁 Project Structure## 🐋 Docker



``````bash

calculator-service/# Build

├── .github/docker build -t calculator-service .

│   └── workflows/

│       └── oci-deploy.yml          # CI/CD pipeline for Oracle Cloud# Run

├── config/docker run -p 8080:8080 calculator-service

│   ├── Dockerfile                  # Multi-stage Docker build

│   ├── docker-compose.yml          # Local development# Or use Docker Compose

│   └── k8s/                        # Kubernetes manifestsdocker-compose up

│       ├── namespace.yaml          # Namespace isolation```

│       ├── configmap.yaml          # Configuration

│       ├── deployment-oracle.yaml  # OKE deployment (2 replicas)---

│       └── ingress-prod.yaml       # SSL/Domain (optional)

├── docs/## ☸️ Kubernetes (Phase 2) 🆕

│   ├── ORACLE-CLOUD-KUBERNETES-GUIDE.md    # Complete OCI setup

│   ├── GITHUB-SECRETS-SETUP.md             # CI/CD configuration### Quick Start (All-in-One)

│   ├── PHASE2-KUBERNETES-TUTORIAL.md       # K8s learning guide```powershell

│   ├── PHASE2-QUICK-REFERENCE.md           # Quick commands# Automated setup (runs all 4 steps)

│   ├── PROGRESS.md                         # Learning journey.\quickstart.ps1

│   └── *.md                                # Other guides```

├── scripts/

│   ├── k8s-setup.ps1              # Local K8s setup### Manual Steps

│   ├── k8s-deploy.ps1             # Deploy to Minikube```powershell

│   └── k8s-cleanup.ps1            # Cleanup resources# 1. Setup (installs kubectl, minikube)

├── src/.\scripts\k8s-setup.ps1

│   ├── main/java/                 # Application code

│   └── test/java/                 # Unit tests# 2. Start Minikube cluster

├── pom.xml                        # Maven dependencies.\scripts\k8s-start.ps1

└── README.md                      # This file

```# 3. Deploy to Kubernetes

.\scripts\k8s-deploy.ps1

---

# 4. Test deployment

## 🎯 API Endpoints.\scripts\k8s-test.ps1

```

### Calculator Operations

```http### Access Your Service

POST /api/calculate```powershell

Content-Type: application/json# Method 1: Port forward

kubectl port-forward -n calculator service/calculator-service 8080:80

{

  "num1": 10,# Method 2: Get Minikube URL

  "num2": 5,minikube service calculator-service -n calculator --url

  "operation": "add"  // add, subtract, multiply, divide

}# Method 3: Dashboard

```minikube dashboard

```

### Health & Monitoring

- **Health:** `GET /actuator/health`### Scale Your App

- **Liveness:** `GET /actuator/health/liveness````powershell

- **Readiness:** `GET /actuator/health/readiness`# Scale to 5 replicas

- **Metrics:** `GET /actuator/metrics`kubectl scale deployment calculator-service --replicas=5 -n calculator

- **Swagger UI:** `GET /swagger-ui/index.html`

# View pods

---kubectl get pods -n calculator

```

## 🚢 Deployment

### Cleanup

### Option 1: Local Minikube (Learning)```powershell

```powershell.\scripts\k8s-cleanup.ps1

# Start Minikube```

minikube start

📚 **Full Tutorial:** `docs/PHASE2-KUBERNETES-TUTORIAL.md`  

# Build image in Minikube📋 **Quick Reference:** `docs/PHASE2-QUICK-REFERENCE.md`

minikube docker-env | Invoke-Expression

docker build -f config/Dockerfile -t calculator-service:latest .---



# Deploy## 🧪 Testing

kubectl apply -f config/k8s/namespace.yaml

kubectl apply -f config/k8s/configmap.yamlRun all tests with PowerShell:

kubectl apply -f config/k8s/deployment-oracle.yaml```powershell

.\scripts\test-deployment.ps1

# Access```

kubectl port-forward -n calculator service/calculator-service 8080:80

```---



### Option 2: Oracle Cloud (Production) ⭐ **RECOMMENDED**## 🚀 CI/CD Pipeline



#### PrerequisitesPipeline includes:

1. Oracle Cloud account (Free tier)- ✅ Build & Test (Java 21)

2. OKE cluster created- ✅ Docker Build & Push

3. GitHub secrets configured- ✅ Security Scan (OWASP)

- ✅ Auto-deploy to Railway

**Step-by-step guides:**

- [Oracle Cloud Setup](docs/ORACLE-CLOUD-KUBERNETES-GUIDE.md)---

- [GitHub Secrets](docs/GITHUB-SECRETS-SETUP.md)

## 📁 Project Structure

#### Automatic Deployment

```bash```

# Every push to main automatically deploys!.

git add .├── src/                         # Source code

git commit -m "feat: new feature"│   ├── main/java/              # Application code

git push origin main│   └── test/java/              # Tests

│

# Watch deployment├── config/                      # Configuration files

# https://github.com/sethiyasanskar63/calculator-service/actions│   ├── k8s/                    # Kubernetes manifests

```│   │   ├── deployment.yaml     # App deployment

│   │   ├── namespace.yaml      # Isolated environment

---│   │   ├── configmap.yaml      # Configuration

│   │   └── ingress.yaml        # HTTP routing

## 🧪 Testing│   ├── helm-chart/             # Helm charts

│   ├── Dockerfile              # Docker configuration

### Run Tests Locally│   ├── docker-compose.yml      # Multi-container setup

```bash│   └── .dockerignore           # Docker ignore rules

# Unit tests│

./mvnw test├── scripts/                     # Automation scripts

│   ├── k8s-setup.ps1           # Setup kubectl & Minikube

# With coverage│   ├── k8s-start.ps1           # Start Minikube cluster

./mvnw verify│   ├── k8s-deploy.ps1          # Deploy to Kubernetes

│   ├── k8s-test.ps1            # Test deployment

# View coverage report│   ├── k8s-cleanup.ps1         # Cleanup resources

open target/site/jacoco/index.html│   ├── test-deployment.ps1     # Test Docker deployment

```│   └── check-status.ps1        # Check service status

│

### CI/CD Testing├── docs/                        # Documentation

- ✅ Automatic tests on every push/PR│   ├── PHASE2-KUBERNETES-TUTORIAL.md

- ✅ Coverage reports in PR comments│   ├── PHASE2-QUICK-REFERENCE.md

- ✅ Security scanning (Trivy)│   ├── PHASE2-SETUP-COMPLETE.md

- ✅ Test result summaries│   ├── PROGRESS.md

│   ├── MICROSERVICES-ARCHITECTURE.md

---│   ├── HELM-GUIDE.md

│   ├── K8S-LOCAL-GUIDE.md

## 📊 Monitoring│   ├── SPRING-CLOUD-GATEWAY-GUIDE.md

│   └── SPRING-VS-K8S-CHEATSHEET.md

### Kubernetes Commands│

```bash├── .github/                     # GitHub configuration

# Get pods│   └── workflows/              # CI/CD pipelines

kubectl get pods -n calculator│       └── ci-cd.yml

│

# View logs├── pom.xml                      # Maven dependencies

kubectl logs -n calculator -l app=calculator-service└── README.md                    # This file

```

# Scale deployment

kubectl scale deployment calculator-service -n calculator --replicas=5---



# Check service## 📚 Documentation

kubectl get service -n calculator

```- **Architecture:** `docs/MICROSERVICES-ARCHITECTURE.md`

- **Kubernetes Tutorial:** `docs/PHASE2-KUBERNETES-TUTORIAL.md` 🆕

### Access Application- **Quick Reference:** `docs/PHASE2-QUICK-REFERENCE.md` 🆕

```bash- **Progress Tracker:** `docs/PROGRESS.md` 🆕

# Get LoadBalancer IP- **Helm Guide:** `docs/HELM-GUIDE.md`

kubectl get service calculator-service -n calculator- **Local K8s:** `docs/K8S-LOCAL-GUIDE.md`



# Test health---

curl http://<EXTERNAL-IP>/actuator/health

## 🎓 Learning Resources

# Use API

curl -X POST http://<EXTERNAL-IP>/api/calculate \This project demonstrates:

  -H "Content-Type: application/json" \- ✅ RESTful API design

  -d '{"num1": 15, "num2": 3, "operation": "multiply"}'- ✅ Spring Boot best practices

```- ✅ Docker containerization

- ✅ Docker Compose orchestration

---- 🚀 Kubernetes deployment (Phase 2)

- 🚀 Scaling & load balancing

## 🎓 Learning Resources- 🚀 Zero-downtime updates

- ⏸️ Microservices architecture (Phases 3-6)

This project is part of a **6-phase microservices learning journey**:

---

| Phase | Topic | Status | Guide |

|-------|-------|--------|-------|## 📝 License

| **Phase 1** | Docker Fundamentals | ✅ Complete | - |

| **Phase 2** | Kubernetes Basics | ✅ Complete | [Tutorial](docs/PHASE2-KUBERNETES-TUTORIAL.md) |MIT

| **Phase 3** | Second Microservice | 🔜 Next | Coming soon |
| **Phase 4** | API Gateway & Discovery | 📅 Planned | - |
| **Phase 5** | Observability | 📅 Planned | - |
| **Phase 6** | Production Hardening | 📅 Planned | - |

**Detailed Progress:** [PROGRESS.md](docs/PROGRESS.md)

---

## 🛠️ Development

### Prerequisites
- Java 21
- Maven 3.9+
- Docker Desktop
- kubectl
- (Optional) Minikube for local K8s

### Build Commands
```bash
# Clean build
./mvnw clean package

# Skip tests
./mvnw clean package -DskipTests

# Run locally
./mvnw spring-boot:run

# Build Docker image
docker build -f config/Dockerfile -t calculator-service:latest .

# Run with Docker
docker run -p 8080:8080 calculator-service:latest
```

---

## 🔒 Security

- ✅ Automated security scanning (Trivy)
- ✅ No hardcoded secrets (uses K8s ConfigMaps/Secrets)
- ✅ Non-root container user
- ✅ Minimal base image (eclipse-temurin Alpine)
- ✅ Regular dependency updates

---

## 💰 Cost

**Oracle Cloud Always Free Tier:**
- ✅ 2 ARM VMs (4 OCPUs, 24GB RAM total)
- ✅ 200GB block storage
- ✅ 1 LoadBalancer
- ✅ 10TB outbound data/month
- ✅ **Total: $0/month forever**

---

## 🤝 Contributing

This is a learning project, but feedback is welcome!

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

---

## 📚 Documentation

| Document | Description |
|----------|-------------|
| [Oracle Cloud Guide](docs/ORACLE-CLOUD-KUBERNETES-GUIDE.md) | Complete OCI/OKE setup |
| [GitHub Secrets](docs/GITHUB-SECRETS-SETUP.md) | CI/CD configuration |
| [Kubernetes Tutorial](docs/PHASE2-KUBERNETES-TUTORIAL.md) | K8s learning guide |
| [Quick Reference](docs/PHASE2-QUICK-REFERENCE.md) | Common commands |
| [Spring vs K8s](docs/SPRING-VS-K8S-CHEATSHEET.md) | Feature comparison |
| [Progress Tracker](docs/PROGRESS.md) | Learning journey |

---

## 📜 License

This project is part of a personal learning journey in microservices architecture.

---

## 🙏 Acknowledgments

- Spring Boot team for excellent framework
- Oracle Cloud for generous free tier
- Kubernetes community for amazing tools
- GitHub Actions for CI/CD automation

---

## 📞 Contact

**GitHub:** [@sethiyasanskar63](https://github.com/sethiyasanskar63)

---

**⭐ Star this repo if you find it helpful for your Kubernetes learning journey!**
