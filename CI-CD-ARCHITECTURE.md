# CI/CD Pipeline Architecture

## Complete Flow Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                         DEVELOPER WORKFLOW                          │
└─────────────────────────────────────────────────────────────────────┘
                                 │
                                 ▼
                    ┌────────────────────────┐
                    │  1. Code Changes       │
                    │     - Fix bugs         │
                    │     - Add features     │
                    │     - Update docs      │
                    └───────────┬────────────┘
                                │
                                ▼
                    ┌────────────────────────┐
                    │  2. Commit & Push      │
                    │     git add .          │
                    │     git commit -m ""   │
                    │     git push origin main│
                    └───────────┬────────────┘
                                │
┌───────────────────────────────┼────────────────────────────────────┐
│                               ▼                 GITHUB ACTIONS      │
│                  ┌────────────────────────┐                        │
│                  │  3. Trigger Workflow   │                        │
│                  │     - Push detected    │                        │
│                  │     - Start pipeline   │                        │
│                  └───────────┬────────────┘                        │
│                              │                                      │
│        ┌─────────────────────┴─────────────────────┐              │
│        ▼                                           ▼               │
│  ┌──────────────────┐                   ┌──────────────────┐     │
│  │ JOB 1: BUILD     │                   │ JOB 3: SECURITY  │     │
│  │                  │                   │                  │     │
│  │ ✓ Checkout code  │                   │ ✓ Scan deps     │     │
│  │ ✓ Setup Java 21  │                   │ ✓ Find CVEs     │     │
│  │ ✓ Maven build    │                   │ ✓ Generate      │     │
│  │ ✓ Run tests      │                   │   report        │     │
│  │ ✓ Save JAR       │                   │                  │     │
│  └────────┬─────────┘                   └──────────────────┘     │
│           │                                                        │
│           ▼                                                        │
│  ┌──────────────────┐                                            │
│  │ JOB 2: DOCKER    │                                            │
│  │                  │                                            │
│  │ ✓ Download JAR   │                                            │
│  │ ✓ Login DockerHub│                                            │
│  │ ✓ Build image    │                                            │
│  │ ✓ Tag image      │                                            │
│  │ ✓ Push to Hub    │                                            │
│  └────────┬─────────┘                                            │
└───────────┼──────────────────────────────────────────────────────┘
            │
            ▼
┌─────────────────────────────────────────────────────────────────────┐
│                          DOCKER HUB                                 │
│                                                                      │
│  📦 calculator-service:latest                                       │
│  📦 calculator-service:main-abc123                                  │
│  📦 calculator-service:main                                         │
│                                                                      │
│  Available for deployment anywhere!                                 │
└───────────────────────────┬─────────────────────────────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        ▼                   ▼                   ▼
  ┌──────────┐       ┌──────────┐       ┌──────────┐
  │  LOCAL   │       │  AZURE   │       │   AWS    │
  │  DOCKER  │       │   CLOUD  │       │  CLOUD   │
  └──────────┘       └──────────┘       └──────────┘
```

## Detailed Step-by-Step Breakdown

### 📝 **Stage 1: Code Commit**
```
Developer → Writes code → Commits → Pushes to GitHub
Time: Instant
```

### 🔧 **Stage 2: Build & Test Job** (2-3 minutes)
```
Step 1: Checkout code              [10s]
  ├─ Clone repository
  └─ Fetch all files

Step 2: Setup Java 21              [30s]
  ├─ Download JDK (cached after first run)
  ├─ Configure environment
  └─ Setup Maven cache

Step 3: Build application          [45s]
  ├─ Download dependencies (cached)
  ├─ Compile source code
  └─ Create JAR file

Step 4: Run tests                  [30s]
  ├─ Execute unit tests
  ├─ Generate test reports
  └─ Verify coverage

Step 5: Upload artifact            [5s]
  ├─ Save JAR file
  └─ Share with next job
```

### 🐳 **Stage 3: Docker Build Job** (1-2 minutes)
```
Step 1: Download JAR               [5s]
  └─ Get artifact from Build job

Step 2: Login to Docker Hub        [5s]
  └─ Authenticate with token

Step 3: Build Docker image         [40s]
  ├─ Use Dockerfile
  ├─ Copy JAR into image
  └─ Create layers

Step 4: Tag image                  [2s]
  ├─ latest
  ├─ main-abc123 (commit SHA)
  └─ main (branch name)

Step 5: Push to Docker Hub         [30s]
  └─ Upload image (with caching)
```

### 🔐 **Stage 4: Security Scan Job** (1-2 minutes, runs in parallel)
```
Step 1: Checkout code              [10s]
Step 2: Setup Java                 [30s]
Step 3: Run OWASP check            [60s]
  ├─ Scan dependencies
  ├─ Check for CVEs
  └─ Generate HTML report
```

## 🎯 Pipeline Execution Matrix

| Trigger | Build & Test | Docker Push | Security Scan |
|---------|--------------|-------------|---------------|
| Push to main | ✅ Yes | ✅ Yes | ✅ Yes |
| Pull Request | ✅ Yes | ❌ No | ✅ Yes |
| Manual Run | ✅ Yes | ✅ Yes | ✅ Yes |

## 📊 Timeline Example

```
00:00 ─┬─ Push code to GitHub
       │
00:01 ─┼─ GitHub Actions triggered
       │
00:02 ─┼─ Build job starts
       │   └─ Checkout code (10s)
       │
00:03 ─┼─ Setup Java 21 (30s)
       │   Security scan starts in parallel
       │
00:04 ─┼─ Maven build (45s)
       │
00:05 ─┼─ Run tests (30s)
       │   Security scan running
       │
00:06 ─┼─ Upload JAR (5s)
       │   Build job complete ✓
       │
00:07 ─┼─ Docker job starts
       │   └─ Download JAR (5s)
       │
00:08 ─┼─ Build Docker image (40s)
       │   Security scan complete ✓
       │
00:09 ─┼─ Push to Docker Hub (30s)
       │
00:10 ─┴─ All jobs complete ✓
           Docker image available!
```

## 🔄 Caching Strategy

**What Gets Cached:**
- ✅ Maven dependencies (~1GB)
- ✅ Docker image layers
- ✅ Java JDK download

**Benefits:**
- First run: ~5 minutes
- Subsequent runs: ~2-3 minutes (60% faster!)

## 🎨 Visual Status Indicators

### On GitHub Actions Tab

```
✅ Build and Test       [Success] [2m 15s]
✅ Docker Build & Push  [Success] [1m 45s]
✅ Security Scan        [Success] [2m 05s]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Pipeline completed in 3 minutes
```

### On README Badge

```markdown
![CI/CD](https://img.shields.io/github/workflow/status/user/repo/CI-CD%20Pipeline?style=flat-square)
```

Shows: ![CI/CD Passing](https://img.shields.io/badge/CI%2FCD-passing-brightgreen)

## 🚨 Failure Scenarios

### If Build Fails:
```
❌ Build and Test       [Failed]   [1m 30s]
⏭️ Docker Build & Push  [Skipped]
⏭️ Security Scan        [Skipped]
```
**Action Required:** Fix compilation errors, push again

### If Tests Fail:
```
✅ Build                [Success]  [1m 15s]
❌ Run Tests           [Failed]   [0m 45s]
⏭️ Docker Build & Push  [Skipped]
```
**Action Required:** Fix failing tests, push again

### If Docker Push Fails:
```
✅ Build and Test       [Success]  [2m 15s]
❌ Docker Build & Push  [Failed]   [1m 00s]
✅ Security Scan        [Success]  [2m 05s]
```
**Action Required:** Check Docker Hub credentials

## 📈 Success Metrics

After successful pipeline:
- ✅ **Code Quality**: All tests pass
- ✅ **Security**: No critical vulnerabilities
- ✅ **Availability**: Docker image ready
- ✅ **Traceability**: Tagged with commit SHA
- ✅ **Documentation**: Swagger docs included

---

**This pipeline ensures every code change is automatically built, tested, and deployed!** 🎉
