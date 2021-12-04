#!/bin/sh

DRONE_DIR=$(pwd)
mkdir /public
cd /public
git init
git remote add origin https://baalajimaestro:${GITEA_TOKEN}@git.baalajimaestro.me/baalajimaestro/personal-website.git

echo -e "Deploying updates to GitHub..."
cd $DRONE_DIR
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