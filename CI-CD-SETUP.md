# 🚀 CI/CD Pipeline Setup Guide

## Overview

This project uses **GitHub Actions** for Continuous Integration and Continuous Deployment (CI/CD). The pipeline automatically builds, tests, and deploys the application whenever code is pushed to the repository.

## 📋 Pipeline Stages

### 1️⃣ **Build and Test**
- Checks out the code
- Sets up Java 21 environment
- Compiles the application
- Runs all unit tests
- Generates test coverage reports
- Creates JAR artifact

### 2️⃣ **Docker Build and Push**
- Downloads the JAR from previous stage
- Builds Docker image
- Pushes to Docker Hub
- Tags with branch name, commit SHA, and 'latest'

### 3️⃣ **Security Scan** (Optional)
- Scans dependencies for known vulnerabilities
- Generates security report

## 🔧 Setup Instructions

### Prerequisites

1. **GitHub Repository** - Your code must be in a GitHub repository
2. **Docker Hub Account** - Free account at https://hub.docker.com
3. **GitHub Secrets** - Store sensitive credentials

### Step-by-Step Setup

#### **Step 1: Create Docker Hub Account**

1. Go to https://hub.docker.com
2. Sign up for a free account
3. Create an access token:
   - Click your username → Account Settings
   - Security → New Access Token
   - Name it "github-actions"
   - Copy the token (you'll need it in Step 3)

#### **Step 2: Push Code to GitHub**

```powershell
# Initialize git repository (if not already done)
git init

# Add all files
git add .

# Commit
git commit -m "Add CI/CD pipeline with GitHub Actions"

# Add remote repository (replace with your repo URL)
git remote add origin https://github.com/YOUR_USERNAME/calculator-service.git

# Push to GitHub
git push -u origin main
```

#### **Step 3: Add GitHub Secrets**

1. Go to your GitHub repository
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add these two secrets:

   **Secret 1: DOCKERHUB_USERNAME**
   - Name: `DOCKERHUB_USERNAME`
   - Value: Your Docker Hub username

   **Secret 2: DOCKERHUB_TOKEN**
   - Name: `DOCKERHUB_TOKEN`
   - Value: The access token you created in Step 1

#### **Step 4: Enable GitHub Actions**

1. Go to your repository on GitHub
2. Click the **Actions** tab
3. If prompted, click "I understand my workflows, go ahead and enable them"

## 🎯 How It Works

### Automatic Triggers

The pipeline runs automatically when:

✅ **Push to main/master** - Full pipeline (build, test, Docker push)
✅ **Pull Request** - Build and test only (no Docker push)
✅ **Manual Trigger** - Can trigger manually from GitHub UI

### Workflow Diagram

```
┌─────────────────┐
│  Code Push      │
│  to main/master │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ 1. Build & Test │◄── Checkout code
│                 │    Setup Java 21
│                 │    Compile with Maven
│                 │    Run tests
│                 │    Upload JAR artifact
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ 2. Docker Build │◄── Download JAR
│    & Push       │    Build Docker image
│                 │    Push to Docker Hub
│                 │    Tag: latest, branch, SHA
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ 3. Security     │◄── Scan dependencies
│    Scan         │    Generate report
└─────────────────┘
```

## 📊 Viewing Pipeline Results

### On GitHub

1. Go to your repository
2. Click the **Actions** tab
3. See all workflow runs with their status
4. Click any run to see detailed logs

### Pipeline Badges

Add this to your `README.md` to show build status:

```markdown
![CI/CD Pipeline](https://github.com/YOUR_USERNAME/calculator-service/actions/workflows/ci-cd.yml/badge.svg)
```

## 🐳 Docker Image

After successful pipeline run, your Docker image will be available at:

```
docker pull YOUR_DOCKERHUB_USERNAME/calculator-service:latest
```

### Available Tags

- `latest` - Latest version from main branch
- `main-abc123` - Specific commit SHA
- `main` - Latest from main branch

## 🔍 Understanding Each Step

### Job 1: Build and Test

```yaml
- name: Checkout code          # Downloads your code
- name: Set up JDK 21         # Installs Java 21
- name: Build with Maven      # Compiles application
- name: Run tests             # Executes unit tests
- name: Upload JAR artifact   # Saves JAR for Docker build
```

**Why?** Ensures code compiles and all tests pass before deploying.

### Job 2: Docker Build and Push

```yaml
- name: Download JAR artifact  # Gets JAR from previous job
- name: Login to Docker Hub   # Authenticates with Docker Hub
- name: Build and push        # Creates and uploads Docker image
```

**Why?** Creates a deployable container image and stores it in Docker Hub.

### Job 3: Security Scan

```yaml
- name: OWASP Dependency Check # Scans for vulnerabilities
```

**Why?** Identifies security issues in dependencies before deployment.

## 🚨 Troubleshooting

### Common Issues

**❌ Error: "Secret DOCKERHUB_USERNAME not found"**
- **Solution**: Add the secret in GitHub Settings → Secrets

**❌ Error: "Permission denied when pushing to Docker Hub"**
- **Solution**: Check your Docker Hub token has write permissions

**❌ Error: "Tests failed"**
- **Solution**: Fix failing tests locally first, then push

**❌ Error: "mvnw: Permission denied"**
- **Solution**: Make mvnw executable:
  ```bash
  git update-index --chmod=+x mvnw
  git commit -m "Make mvnw executable"
  ```

## 🎓 Next Steps

Once CI/CD is working:

1. ✅ **Add deployment to cloud** (Azure, AWS, etc.)
2. ✅ **Set up staging environment**
3. ✅ **Add integration tests**
4. ✅ **Configure notifications** (Slack, email)
5. ✅ **Add code quality checks** (SonarQube)

## 📚 Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Docker Hub Documentation](https://docs.docker.com/docker-hub/)
- [Maven GitHub Actions](https://github.com/actions/setup-java)

## 🔐 Security Best Practices

✅ **Never commit secrets** to the repository
✅ **Use GitHub Secrets** for sensitive data
✅ **Rotate tokens regularly**
✅ **Enable 2FA** on Docker Hub and GitHub
✅ **Review dependency vulnerabilities** from security scan

## 📝 Customization

### To modify the pipeline:

1. Edit `.github/workflows/ci-cd.yml`
2. Commit and push changes
3. Pipeline automatically uses new configuration

### Example: Add Slack notifications

```yaml
- name: Slack Notification
  uses: 8398a7/action-slack@v3
  with:
    status: ${{ job.status }}
    webhook_url: ${{ secrets.SLACK_WEBHOOK }}
```

## ✅ Quick Checklist

Before pushing to GitHub:

- [ ] Code compiles locally
- [ ] All tests pass locally
- [ ] Docker Hub account created
- [ ] GitHub Secrets configured
- [ ] `.github/workflows/ci-cd.yml` exists
- [ ] `mvnw` is executable (chmod +x)
- [ ] `.gitignore` includes `target/`, `*.jar`

---

**Your CI/CD pipeline is now ready! Every push to main will automatically build, test, and deploy your application.** 🎉
