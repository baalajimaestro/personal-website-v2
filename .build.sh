#! /bin/sh

apk add git py3-pip python3
git config --global user.name baalajimaestro
git config --global user.email me@baalajimaestro.me
pip3 install GitPython
export HUGO_ENV=production
python3 .buildpush.py
