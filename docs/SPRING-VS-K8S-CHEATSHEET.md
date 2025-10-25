# Quick Reference: Spring Cloud vs Kubernetes

## 🎯 One-Page Cheat Sheet

### The Simple Answer

**Spring Cloud** = Application-level tools for Java microservices  
**Kubernetes** = Platform-level tools for running containers  
**API Gateway** = Single entry point for all your services

---

## 📊 Feature Mapping

| I Need... | Spring Cloud Solution | Kubernetes Solution | Best Choice |
|-----------|----------------------|---------------------|-------------|
| **Route requests** | Spring Cloud Gateway | Ingress Controller | Gateway (richer) |
| **Find services** | Netflix Eureka | DNS + Services | K8s (native) |
| **Load balance** | Spring Cloud LoadBalancer | Service | K8s (automatic) |
| **Configuration** | Config Server | ConfigMaps/Secrets | Config (dynamic) |
| **Circuit breaker** | Resilience4j | Istio/Linkerd | Resilience4j (easier) |
| **Rate limiting** | Gateway filters | NGINX/Envoy | Tie |
| **Authentication** | Spring Security + Gateway | Istio/OAuth2 Proxy | Spring (integrated) |
| **Monitoring** | Micrometer | Prometheus | Both work together |
| **Tracing** | Sleuth + Zipkin | Jaeger | Tie |
| **Service mesh** | N/A | Istio/Linkerd | K8s only option |

---

## 🏗️ Architecture Patterns

### Pattern 1: Spring Cloud Only (No Kubernetes)
```
┌─────────────┐
│ Clients     │
└──────┬──────┘
       │
   ┌───┴────┐
   │Gateway │ (Spring Cloud Gateway)
   └───┬────┘
       │
   ┌───┴────┐
   │ Eureka │ (Service Discovery)
   └───┬────┘
       │
    ┌──┴──┬──────┬──────┐
    │Svc1 │ Svc2 │ Svc3 │
    └─────┴──────┴──────┘

Running on: VMs, EC2, App Service
Good for: Traditional deployments
```

### Pattern 2: Kubernetes Only (No Spring Cloud)
```
┌─────────────┐
│ Clients     │
└──────┬──────┘
       │
   ┌───┴────┐
   │Ingress │ (NGINX/Traefik)
   └───┬────┘
       │
    ┌──┴──┬──────┬──────┐
    │Svc1 │ Svc2 │ Svc3 │ (K8s Services)
    └──┬──┴──┬───┴──┬───┘
       │     │      │
    ┌──┴──┐┌─┴───┐┌┴────┐
    │Pods ││Pods ││Pods │
    └─────┘└─────┘└─────┘

Running on: Kubernetes
Good for: Cloud-native, polyglot
```

### Pattern 3: Hybrid (Best of Both) ⭐
```
┌─────────────┐
│ Clients     │
└──────┬──────┘
       │
┌──────┴───────────────────┐
│   Kubernetes Cluster     │
│                          │
│  ┌────────────┐          │
│  │  Ingress   │          │
│  └─────┬──────┘          │
│        │                 │
│  ┌─────┴──────┐          │
│  │   Gateway  │ (Spring) │
│  └─────┬──────┘          │
│        │                 │
│  ┌─────┴───┐             │
│  │  Eureka │             │
│  └─────┬───┘             │
│        │                 │
│   ┌────┴──┬──────┬──┐    │
│   │ Svc1  │ Svc2 │..│    │
│   └───────┴──────┴──┘    │
└──────────────────────────┘

Running on: Kubernetes
Good for: Production, complex routing
```

---

## 🎯 Decision Tree

```
START
  │
  ├─ Do you have Kubernetes?
  │   │
  │   NO → Use Spring Cloud ✅
  │   │
  │   YES → Continue
  │       │
  │       ├─ All services are Spring Boot?
  │       │   │
  │       │   YES → Consider Spring Cloud Gateway ✅
  │       │   │
  │       │   NO → Use Kubernetes Ingress ✅
  │       │
  │       ├─ Need complex routing logic?
  │       │   │
  │       │   YES → Add Spring Cloud Gateway ✅
  │       │   │
  │       │   NO → Kubernetes Ingress is enough ✅
  │       │
  │       └─ Need service mesh features?
  │           │
  │           YES → Use Istio/Linkerd ✅
  │           │
  │           NO → Spring Cloud or K8s native ✅
```

---

## 💡 Real-World Scenarios

### Scenario 1: Startup (1-3 services)
**Use**: Kubernetes Ingress only  
**Why**: Simple, no overhead  
```
Ingress → Service 1, Service 2, Service 3
```

### Scenario 2: Growing (5-10 services)
**Use**: Kubernetes + Spring Cloud Gateway  
**Why**: Need smart routing, auth  
```
Ingress → Gateway → 10 services
```

### Scenario 3: Enterprise (50+ services)
**Use**: Kubernetes + Service Mesh + Gateway  
**Why**: Need observability, security  
```
Ingress → Istio → Gateway → 50+ services
```

---

## 🔧 Configuration Examples

### Example: Rate Limiting

#### Spring Cloud Gateway
```yaml
spring:
  cloud:
    gateway:
      routes:
      - id: calculator
        uri: lb://calculator-service
        predicates:
        - Path=/api/calculator/**
        filters:
        - name: RequestRateLimiter
          args:
            redis-rate-limiter.replenishRate: 10
            redis-rate-limiter.burstCapacity: 20
```

#### Kubernetes Ingress (NGINX)
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: calculator
  annotations:
    nginx.ingress.kubernetes.io/limit-rps: "10"
spec:
  rules:
  - http:
      paths:
      - path: /api/calculator
        pathType: Prefix
        backend:
          service:
            name: calculator-service
            port:
              number: 80
```

**Both work!** Choose based on your stack.

---

## 🚀 Migration Paths

### From Monolith to Microservices

#### Step 1: Containerize
```
Monolith → Docker Container
```

#### Step 2: Deploy to Kubernetes
```
Container → K8s Deployment + Service
```

#### Step 3: Split Services
```
Monolith → Calculator + User + Payment
```

#### Step 4: Add Gateway
```
Services → Behind Spring Cloud Gateway
```

#### Step 5: Add Discovery
```
Services → Register with Eureka
```

---

## ✅ Recommendations

### For Your Calculator Service:

#### Now (Learning Phase)
```
Just Kubernetes
  └── calculator-service (3 pods)
```

#### Next Month (Add 2nd Service)
```
Kubernetes Ingress
  ├── calculator-service
  └── user-service
```

#### Month 3 (Add Gateway)
```
Kubernetes Ingress
  └── Spring Cloud Gateway
      ├── calculator-service
      └── user-service
```

#### Month 6 (Production)
```
Kubernetes Ingress (SSL, DDoS)
  └── Spring Cloud Gateway (Auth, Routing)
      └── Eureka (Discovery)
          ├── calculator-service
          ├── user-service
          ├── payment-service
          └── notification-service
```

---

## 🎓 Learning Order

1. ✅ **Docker** - Containerization (You know this!)
2. ⏳ **Kubernetes** - Orchestration (Learning now)
3. ⬜ **Spring Cloud Gateway** - API Gateway
4. ⬜ **Eureka** - Service Discovery
5. ⬜ **Config Server** - Configuration
6. ⬜ **Resilience4j** - Circuit Breaker
7. ⬜ **Istio/Linkerd** - Service Mesh (Advanced)

---

## 📚 Quick Commands Comparison

### Spring Cloud Gateway (Java Code)
```java
// Define routes programmatically
@Bean
public RouteLocator customRoutes(RouteLocatorBuilder builder) {
    return builder.routes()
        .route("calculator", r -> r.path("/api/calculator/**")
            .uri("lb://calculator-service"))
        .build();
}
```

### Kubernetes Ingress (YAML)
```yaml
# Define routes declaratively
apiVersion: networking.k8s.io/v1
kind: Ingress
spec:
  rules:
  - http:
      paths:
      - path: /api/calculator
        backend:
          service:
            name: calculator-service
```

**Different syntax, same goal!**

---

## 🎯 Bottom Line

| If you want... | Use this |
|----------------|----------|
| **Simplest start** | Kubernetes Ingress |
| **Java-centric** | Spring Cloud |
| **Polyglot (multiple languages)** | Kubernetes native |
| **Best for production** | Kubernetes + Spring Cloud |
| **Learn fundamentals** | Start with K8s, add Spring later |

---

## 🤝 They Work Together!

**Think of it like a car:**
- **Kubernetes** = The road and traffic system
- **Spring Cloud** = Your car's GPS and cruise control

You can:
- Drive without GPS (K8s only) ✅
- Have GPS at home (Spring Cloud only) ✅
- Use both for best experience (Hybrid) ⭐

---

**Bottom line**: Start with Kubernetes to learn the platform, then add Spring Cloud when you need application-level features! 🚀
