# 🆓 Free Deployment Guide

This guide shows you how to deploy your Calculator microservice for **FREE** using popular cloud platforms.

## 🎯 Platform Comparison

| Platform | Free Tier | Best For | Deployment Time |
|----------|-----------|----------|-----------------|
| **Render.com** ⭐ | 750 hrs/month | Easy setup, Docker support | 5 minutes |
| **Railway.app** ⭐ | $5 credit/month | Fastest deployment | 3 minutes |
| **Fly.io** | 3 shared VMs | Advanced users | 10 minutes |

**Recommended: Render.com** (Most generous free tier + easiest setup)

---

## 🚀 Option 1: Deploy to Render.com (RECOMMENDED)

### Why Render?
✅ **750 hours/month free** (enough for 24/7 hosting)
✅ **Automatic HTTPS**
✅ **Zero config deployments** from GitHub
✅ **Auto-deploy on push**
✅ **Docker support**

### Step-by-Step Setup

#### **Step 1: Create Render Account**
1. Go to https://render.com
2. Click "Get Started"
3. Sign up with GitHub (easiest)

#### **Step 2: Create Web Service**

1. Click **"New +"** → **"Web Service"**
2. Click **"Connect account"** → Choose your GitHub repo
3. Fill in the details:

```
Name:            calculator-service
Region:          Oregon (US West) - or closest to you
Branch:          main
Runtime:         Docker
Instance Type:   Free
```

#### **Step 3: Configure Environment**

Click **"Advanced"** and add:

```
Health Check Path: /api/calculator/health
```

#### **Step 4: Deploy!**

1. Click **"Create Web Service"**
2. Wait 3-5 minutes for deployment
3. Get your URL: `https://calculator-service.onrender.com`

### 🎉 That's It!

Your app is now live at:
```
https://calculator-service.onrender.com/api/calculator/health
https://calculator-service.onrender.com/swagger-ui.html
```

### Auto-Deploy

Every time you push to GitHub, Render automatically:
- Pulls latest code
- Runs CI/CD pipeline
- Builds Docker image
- Deploys new version

---

## 🚀 Option 2: Deploy to Railway.app

### Why Railway?
✅ **$5 free credit/month**
✅ **Fastest deployment** (2-3 minutes)
✅ **One-click deployments**
✅ **Great for demos**

### Step-by-Step Setup

#### **Step 1: Create Railway Account**
1. Go to https://railway.app
2. Click "Start a New Project"
3. Sign in with GitHub

#### **Step 2: Deploy from GitHub**

1. Click **"Deploy from GitHub repo"**
2. Select your repository
3. Railway auto-detects Dockerfile

#### **Step 3: Configure**

1. Click on your service
2. Go to **Settings** → **Networking**
3. Click **"Generate Domain"**
4. Add health check path: `/api/calculator/health`

#### **Step 4: Deploy!**

Railway automatically:
- Builds your Docker image
- Deploys the service
- Gives you a URL: `https://calculator-service.up.railway.app`

### 🎉 Done!

Access your app at:
```
https://calculator-service.up.railway.app/api/calculator/health
https://calculator-service.up.railway.app/swagger-ui.html
```

---

## 🚀 Option 3: Deploy to Fly.io

### Why Fly.io?
✅ **3 shared VMs free**
✅ **Global edge deployment**
✅ **Great performance**

### Step-by-Step Setup

#### **Step 1: Install Fly CLI**

```powershell
# Using PowerShell
iwr https://fly.io/install.ps1 -useb | iex
```

#### **Step 2: Authenticate**

```powershell
fly auth signup
# OR
fly auth login
```

#### **Step 3: Create App**

```powershell
fly launch
```

Answer the prompts:
```
App Name:        calculator-service
Region:          Choose closest to you
PostgreSQL:      No
Redis:           No
Deploy now:      Yes
```

#### **Step 4: Deploy**

```powershell
fly deploy
```

Your app is live at: `https://calculator-service.fly.dev`

---

## 📋 Complete GitHub Setup Instructions

### **Step 1: Create GitHub Repository**

1. Go to https://github.com
2. Click **"New repository"**
3. Fill in details:
   ```
   Repository name: calculator-service
   Description:     Java 21 Calculator Microservice with CI/CD
   Visibility:      Public
   Initialize:      NO (we already have code)
   ```
4. Click **"Create repository"**

### **Step 2: Push Your Code**

GitHub will show you commands. Run these:

```powershell
# Change 'YOUR_USERNAME' to your actual GitHub username
git remote add origin https://github.com/YOUR_USERNAME/calculator-service.git
git branch -M main
git push -u origin main
```

### **Step 3: Verify GitHub Actions**

1. Go to your repo on GitHub
2. Click **"Actions"** tab
3. You should see "Initial commit" workflow running
4. Wait for it to complete (✅ green checkmark)

---

## 🐳 Docker Hub Setup (For CI/CD)

### **Step 1: Create Docker Hub Account**

1. Go to https://hub.docker.com
2. Sign up (free)
3. Verify your email

### **Step 2: Create Access Token**

1. Click your username → **Account Settings**
2. **Security** → **New Access Token**
3. Name: `github-actions`
4. Permissions: **Read, Write, Delete**
5. Click **Generate**
6. **COPY THE TOKEN** (you'll need it next)

### **Step 3: Add GitHub Secrets**

1. Go to your GitHub repo
2. **Settings** → **Secrets and variables** → **Actions**
3. Click **"New repository secret"**

Add these two secrets:

**Secret 1:**
```
Name:  DOCKERHUB_USERNAME
Value: your-dockerhub-username
```

**Secret 2:**
```
Name:  DOCKERHUB_TOKEN
Value: paste-the-token-you-copied
```

4. Click **"Add secret"** for each

---

## ✅ Verification Checklist

After setup, verify everything works:

### GitHub
- [ ] Repository created
- [ ] Code pushed
- [ ] Actions tab shows successful build
- [ ] Docker Hub secrets added

### CI/CD Pipeline
- [ ] Build and Test job passes
- [ ] Docker Build & Push job passes
- [ ] Security Scan job completes

### Docker Hub
- [ ] Image appears at: `hub.docker.com/r/YOUR_USERNAME/calculator-service`
- [ ] Tagged with `latest`

### Deployment Platform (Choose one)
- [ ] Render.com service created
- [ ] OR Railway.app project created
- [ ] OR Fly.io app deployed

### Application
- [ ] Health check works: `https://your-app-url.com/api/calculator/health`
- [ ] Swagger UI accessible: `https://your-app-url.com/swagger-ui.html`
- [ ] Calculator API works

---

## 🧪 Test Your Deployed App

### Test Health Endpoint
```powershell
curl https://your-app-url.com/api/calculator/health
```

Expected: `Calculator service is running!`

### Test Calculator API
```powershell
Invoke-RestMethod -Uri https://your-app-url.com/api/calculator/calculate `
  -Method POST `
  -Headers @{"Content-Type"="application/json"} `
  -Body '{"number1": 10, "number2": 5, "operation": "+"}'
```

Expected:
```json
{
  "number1": 10.0,
  "number2": 5.0,
  "operation": "+",
  "result": 15.0,
  "success": true,
  "message": "Calculation successful"
}
```

---

## 💰 Cost Breakdown

### Free Tiers

**Render.com:**
- ✅ 750 hours/month (24/7 for one app)
- ✅ 512MB RAM
- ✅ Automatic HTTPS
- ✅ Auto-deploy from GitHub
- ⚠️ Spins down after 15 min inactivity (free tier)

**Railway.app:**
- ✅ $5 credit/month (~500 hours)
- ✅ 512MB RAM
- ✅ No sleep mode
- ⚠️ Credits expire monthly

**Fly.io:**
- ✅ 3 shared VMs (256MB RAM each)
- ✅ 160GB bandwidth
- ✅ No sleep mode
- ⚠️ More complex setup

### Recommended Setup
```
Development: Render.com (easiest)
Production:  Fly.io (better performance)
Demo/POC:    Railway.app (fastest)
```

---

## 🔄 Deployment Flow

```
Developer Pushes Code
         ↓
GitHub Actions Triggered
         ↓
    Build & Test
         ↓
   Build Docker Image
         ↓
  Push to Docker Hub
         ↓
Platform Auto-Detects New Image
         ↓
  Pulls & Deploys
         ↓
    App is Live!
```

---

## 🆘 Troubleshooting

### "Build failed on GitHub Actions"
- Check Actions tab for error details
- Usually: Tests failing or Maven dependency issues
- Fix locally, commit, push again

### "Docker image not found"
- Check Docker Hub credentials in GitHub Secrets
- Verify DOCKERHUB_USERNAME and DOCKERHUB_TOKEN are correct

### "App not accessible after deployment"
- Check health check path is `/api/calculator/health`
- Verify app is listening on port 8080
- Check deployment logs on platform

### "Render app spinning down"
- Normal on free tier after 15 min inactivity
- Upgrade to paid tier for always-on
- OR use a free uptime monitor (uptimerobot.com)

---

## 🎯 Next Steps

Once deployed:

1. ✅ **Add custom domain** (most platforms support)
2. ✅ **Set up monitoring** (UptimeRobot - free)
3. ✅ **Add database** (PostgreSQL on same platform)
4. ✅ **Enable logging** (Platform built-in)
5. ✅ **Add environment variables** (API keys, etc.)

---

## 📚 Resources

- **Render.com Docs**: https://render.com/docs
- **Railway.app Docs**: https://docs.railway.app
- **Fly.io Docs**: https://fly.io/docs
- **GitHub Actions**: https://docs.github.com/actions

---

**Your microservice is now production-ready and FREE to host!** 🎉
