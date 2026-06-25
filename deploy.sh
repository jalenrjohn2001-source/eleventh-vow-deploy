#!/bin/bash
# One-shot deploy: GitHub repo + Vercel
# Usage: bash deploy.sh

set -e

REPO_NAME="eleventh-vow-materials"
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

echo "→ Setting up git in: $DIR"
if [ ! -d ".git" ]; then
  git init -b main
  git add .
  git commit -m "Initial commit: Eleventh Vow founding venue materials"
fi

echo "→ Creating GitHub repo: $REPO_NAME (private)"
if ! gh repo view "$REPO_NAME" >/dev/null 2>&1; then
  gh repo create "$REPO_NAME" --private --source=. --remote=origin --push
else
  echo "  repo already exists, pushing latest"
  git push -u origin main || true
fi

echo "→ Deploying to Vercel (production)"
vercel deploy --prod --yes

echo ""
echo "✓ Done. Copy the production URL above into your email."
