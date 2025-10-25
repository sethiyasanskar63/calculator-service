# 🔐 GitHub Secrets Setup for Oracle Cloud CI/CD

## Overview
This guide shows you how to configure GitHub repository secrets to enable automated deployment to Oracle Cloud Kubernetes (OKE).

**Time required:** 15-20 minutes
**Prerequisites:** 
- Oracle Cloud account created
- OKE cluster created
- OCI CLI configured locally

---

## 📋 Required GitHub Secrets

You need to add **7 secrets** to your GitHub repository:

| Secret Name | Description | How to Get |
|-------------|-------------|------------|
| `OCI_REGION` | Oracle Cloud region | e.g., `us-ashburn-1`, `us-phoenix-1` |
| `OCI_TENANCY_NAMESPACE` | Your tenancy namespace | Found in Container Registry |
| `OCI_USERNAME` | Your OCI username | Your email or IDCS username |
| `OCI_AUTH_TOKEN` | Authentication token | Generate in OCI Console |
| `OCI_CLI_CONFIG` | OCI CLI config file | Content of `~/.oci/config` |
| `OCI_CLI_KEY` | OCI API private key | Content of `~/.oci/oci_api_key.pem` |
| `OKE_CLUSTER_ID` | OKE cluster OCID | From OKE cluster details |

---

## 🛠️ Step-by-Step Secret Configuration

### Step 1: Get OCI_REGION

This is your home region where you created the cluster.

**Common regions:**
- US East (Ashburn): `us-ashburn-1`
- US West (Phoenix): `us-phoenix-1`
- Europe (Frankfurt): `eu-frankfurt-1`
- Asia Pacific (Mumbai): `ap-mumbai-1`

**How to find:**
1. Login to OCI Console: https://cloud.oracle.com
2. Look at the top-right, next to your profile
3. Shows "Region: US East (Ashburn)" → Use `us-ashburn-1`

**Add to GitHub:**
```
Name: OCI_REGION
Value: us-ashburn-1
```

---

### Step 2: Get OCI_TENANCY_NAMESPACE

**How to find:**
1. In OCI Console → **Developer Services** → **Container Registry**
2. At the top, you'll see: "Namespace: **abc123xyz**"
3. Copy that value

**Example:**
```
Namespace: axabcdefghij
```

**Add to GitHub:**
```
Name: OCI_TENANCY_NAMESPACE
Value: axabcdefghij
```

---

### Step 3: Get OCI_USERNAME

This is the username you use to login to OCI.

**Format:** `<tenancy-namespace>/<username>`

**How to find:**
1. In OCI Console → Click your profile (top-right) → **User Settings**
2. Copy your username (usually your email)

**Example:**
```
Username: john.doe@example.com
```

**Add to GitHub:**
```
Name: OCI_USERNAME
Value: john.doe@example.com
```

**Note:** Some regions use IDCS, format would be: `oracleidentitycloudservice/john.doe@example.com`

---

### Step 4: Generate OCI_AUTH_TOKEN

Auth tokens are used instead of passwords for API access.

**How to create:**
1. In OCI Console → Profile Icon → **User Settings**
2. Scroll down to **Auth Tokens** (left menu)
3. Click **Generate Token**
4. Description: `GitHub Actions CI/CD`
5. Click **Generate Token**
6. **⚠️ COPY IT NOW** (shown only once!)

**Example:**
```
Auth Token: B}f>2Kx.yZ[m<nP$qRs8T@uV!wX_aYb
```

**Add to GitHub:**
```
Name: OCI_AUTH_TOKEN
Value: B}f>2Kx.yZ[m<nP$qRs8T@uV!wX_aYb
```

---

### Step 5: Get OCI_CLI_CONFIG

This is the OCI CLI configuration file created when you ran `oci setup config`.

**On Windows (PowerShell):**
```powershell
# Read and copy the config file
Get-Content "$HOME\.oci\config"
```

**On Linux/Mac:**
```bash
cat ~/.oci/config
```

**Content looks like:**
```ini
[DEFAULT]
user=ocid1.user.oc1..aaaa...
fingerprint=12:34:56:78:90:ab:cd:ef:12:34:56:78:90:ab:cd:ef
tenancy=ocid1.tenancy.oc1..aaaa...
region=us-ashburn-1
key_file=~/.oci/oci_api_key.pem
```

**⚠️ Important:** Replace `key_file=~/.oci/oci_api_key.pem` with `key_file=~/.oci/oci_api_key.pem` (GitHub Actions will create the file)

**Add to GitHub:**
```
Name: OCI_CLI_CONFIG
Value: [Paste entire config file content]
```

---

### Step 6: Get OCI_CLI_KEY

This is your private API key.

**On Windows (PowerShell):**
```powershell
# Read and copy the private key
Get-Content "$HOME\.oci\oci_api_key.pem" -Raw
```

**On Linux/Mac:**
```bash
cat ~/.oci/oci_api_key.pem
```

**Content looks like:**
```
-----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC...
...lots of characters...
...ends with...
-----END PRIVATE KEY-----
```

**⚠️ Important:** Copy the ENTIRE content including `-----BEGIN PRIVATE KEY-----` and `-----END PRIVATE KEY-----`

**Add to GitHub:**
```
Name: OCI_CLI_KEY
Value: [Paste entire private key including BEGIN/END lines]
```

---

### Step 7: Get OKE_CLUSTER_ID

This is the OCID of your Kubernetes cluster.

**How to find:**
1. In OCI Console → **Developer Services** → **Kubernetes Clusters (OKE)**
2. Click on your cluster name (e.g., `calculator-cluster`)
3. In cluster details, find **OCID**
4. Click **Copy** button

**Example:**
```
ocid1.cluster.oc1.iad.aaaaaaaaxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

**Add to GitHub:**
```
Name: OKE_CLUSTER_ID
Value: ocid1.cluster.oc1.iad.aaaaaaaaxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

---

## 🔒 Adding Secrets to GitHub

### Method 1: GitHub Web UI

1. Go to your repository: https://github.com/sethiyasanskar63/calculator-service
2. Click **Settings** tab
3. In left sidebar → **Secrets and variables** → **Actions**
4. Click **New repository secret**
5. Add each secret:
   - Name: `OCI_REGION`
   - Secret: `us-ashburn-1` (your value)
   - Click **Add secret**
6. Repeat for all 7 secrets

### Method 2: GitHub CLI (Faster)

```powershell
# Install GitHub CLI if not already installed
winget install GitHub.cli

# Login
gh auth login

# Add secrets (one by one)
gh secret set OCI_REGION -b"us-ashburn-1"
gh secret set OCI_TENANCY_NAMESPACE -b"your-tenancy-namespace"
gh secret set OCI_USERNAME -b"your-username@example.com"
gh secret set OCI_AUTH_TOKEN -b"your-auth-token"

# For multiline secrets (config and key), use files
gh secret set OCI_CLI_CONFIG < "$HOME\.oci\config"
gh secret set OCI_CLI_KEY < "$HOME\.oci\oci_api_key.pem"

gh secret set OKE_CLUSTER_ID -b"ocid1.cluster.oc1.iad.aaaa..."
```

---

## ✅ Verify Secrets

After adding all secrets:

1. Go to repository → **Settings** → **Secrets and variables** → **Actions**
2. You should see all 7 secrets listed:
   ```
   ✅ OCI_REGION
   ✅ OCI_TENANCY_NAMESPACE
   ✅ OCI_USERNAME
   ✅ OCI_AUTH_TOKEN
   ✅ OCI_CLI_CONFIG
   ✅ OCI_CLI_KEY
   ✅ OKE_CLUSTER_ID
   ```

---

## 🚀 Test the CI/CD Pipeline

### Trigger the Workflow

```powershell
# Make a small change
git add .
git commit -m "test: trigger OCI deployment"
git push origin main
```

### Monitor the Deployment

1. Go to your repository → **Actions** tab
2. Click on the latest workflow run
3. Watch the jobs execute:
   - ✅ Build and Test
   - ✅ Build and Push to OCI Registry
   - ✅ Deploy to Oracle Kubernetes
   - ✅ Security Scan

### Check Deployment Status

```powershell
# Get external IP
kubectl get service calculator-service -n calculator

# Test the app
$IP = "xxx.xxx.xxx.xxx"  # Replace with LoadBalancer IP
Invoke-RestMethod -Uri "http://$IP/actuator/health"
```

---

## 🔧 Troubleshooting

### Error: "ServiceError: The user is not authorized"
- **Cause:** Incorrect OCI credentials
- **Fix:** Double-check `OCI_USERNAME`, `OCI_AUTH_TOKEN`, and `OCI_CLI_CONFIG`

### Error: "Could not find cluster"
- **Cause:** Wrong `OKE_CLUSTER_ID` or `OCI_REGION`
- **Fix:** Verify cluster OCID and region match

### Error: "Failed to push image"
- **Cause:** Registry authentication failed
- **Fix:** 
  1. Verify `OCI_TENANCY_NAMESPACE` is correct
  2. Check `OCI_AUTH_TOKEN` is valid
  3. Ensure Container Registry repository exists

### Error: "kubectl: command not found"
- **Cause:** kubeconfig not set up correctly
- **Fix:** Check `OCI_CLI_CONFIG` and `OCI_CLI_KEY` are complete

---

## 📊 What Happens on Each Push

```
1. Push to main branch
   ↓
2. GitHub Actions triggered
   ↓
3. Build & Test (Maven)
   ↓
4. Build Docker image
   ↓
5. Push to OCI Container Registry
   ↓
6. Connect to OKE cluster
   ↓
7. Deploy new version (rolling update)
   ↓
8. Health check
   ↓
9. Deployment complete! ✅
```

---

## 🎯 Next Steps

After successful setup:

1. ✅ Every push to `main` automatically deploys to OKE
2. ✅ Zero-downtime rolling updates
3. ✅ Automatic rollback if health checks fail
4. ✅ Test coverage reports on PRs
5. ✅ Security scanning

**Optional enhancements:**
- Add staging environment (deploy PRs to staging)
- Setup monitoring (Prometheus + Grafana)
- Configure auto-scaling
- Add Slack/Discord notifications

---

## 📚 Resources

- [GitHub Actions Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [OCI CLI Configuration](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/sdkconfig.htm)
- [OCI Auth Tokens](https://docs.oracle.com/en-us/iaas/Content/Registry/Tasks/registrygettingauthtoken.htm)
- [Kubernetes Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)

---

**🎉 Congratulations!** Your CI/CD pipeline is ready to deploy to Oracle Cloud automatically! 🚀
