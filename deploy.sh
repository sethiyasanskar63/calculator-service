#!/bin/bash
# Quick deployment script for Render.com

echo "🚀 Deploying Calculator Service to Render.com"
echo "=============================================="
echo ""

# Check if git is initialized
if [ ! -d .git ]; then
    echo "❌ Error: Not a git repository"
    echo "Run: git init"
    exit 1
fi

# Check if remote is set
if ! git remote get-url origin > /dev/null 2>&1; then
    echo "⚠️  No git remote found"
    echo ""
    echo "Please add your GitHub repository:"
    echo "  git remote add origin https://github.com/YOUR_USERNAME/calculator-service.git"
    echo ""
    exit 1
fi

# Commit any changes
echo "📝 Checking for uncommitted changes..."
if [[ -n $(git status -s) ]]; then
    echo "Found uncommitted changes. Committing..."
    git add .
    git commit -m "Deploy: $(date '+%Y-%m-%d %H:%M:%S')"
else
    echo "✅ No uncommitted changes"
fi

# Push to GitHub
echo ""
echo "📤 Pushing to GitHub..."
git push origin main

echo ""
echo "✅ Code pushed to GitHub!"
echo ""
echo "Next steps:"
echo "1. GitHub Actions will build and test your code"
echo "2. Docker image will be pushed to Docker Hub"
echo "3. Render.com will auto-deploy the new version"
echo ""
echo "Check status:"
echo "  GitHub Actions: https://github.com/$(git remote get-url origin | sed 's/.*github.com[:/]//;s/.git$//')/actions"
echo "  Render Dashboard: https://dashboard.render.com"
echo ""
