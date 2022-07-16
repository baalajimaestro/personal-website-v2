#!/bin/sh

BASE_DIR=$(pwd)

git clone https://${GITLAB_USERNAME}:${GITLAB_TOKEN}@git.baalajimaestro.me/baalajimaestro/${CONTENT_REPO_GIT} content
rm -rf content/.obsidian
rm -rf content/.gitlab-ci.yml

mkdir /public
cd /public
git init
git remote add origin https://baalajimaestro:${CI_JOB_TOKEN}@git.baalajimaestro.me/baalajimaestro/personal-website.git

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
