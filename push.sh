#!/bin/bash
mkdir /public
cd /public
git init
git remote add origin https://baalajimaestro:${GH_PERSONAL_TOKEN}@github.com/baalajimaestro/personal-website

echo -e "Deploying updates to GitHub..."
cd /app
hugo -d /public

# Go To Public folder
cd /public

# Add changes to git.
git add .

# Commit changes.
git commit -m "[MaestroCI]: Binaries as of $(date +%Y-%m-%d_%H:%M:%S)" --signoff

# Push source and build repos.
git push -f origin master