#! /bin/sh

apk add --no-cache python3 py3-pip git
git config --global user.name baalajimaestro
git config --global user.email me@baalajimaestro.me
pip3 install GitPython
export HUGO_ENV=production
python3 .buildpush.py
