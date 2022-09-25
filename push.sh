#!/bin/sh

BASE_DIR=$(pwd)
REPO="https://${CONTENT_REPO_USERNAME}:${CONTENT_REPO_TOKEN}@git.baalajimaestro.me/baalajimaestro/${CONTENT_REPO_GIT}"
git clone "$REPO" -b $(git ls-remote --tags --refs "$REPO" | tail -n1 | cut -d/ -f3) content
rm -rf content/.obsidian
rm -rf content/.gitlab-ci.yml

mkdir /public
cd /public
git init
git remote add origin https://${REPO_DEPLOY_USERNAME}:${REPO_DEPLOY_TOKEN}@git.baalajimaestro.me/baalajimaestro/personal-website.git

echo -e "Deploying updates to GitHub..."
cd $BASE_DIR
hugo mod get -u
hugo --gc --minify -d /public

# Go To Public folder
cd /public

# Add changes to git.
git add .

# Commit changes.
git commit -m "[MaestroCI]: Binaries as of $(date +%Y-%m-%d_%H:%M:%S)" --signoff

# Push source and build repos.
git push -f origin master
