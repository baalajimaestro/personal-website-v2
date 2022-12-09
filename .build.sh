#! /bin/sh

apk update && apk add python3 py3-pip git go
git config --global user.name baalajimaestro
git config --global user.email me@baalajimaestro.me
pip3 install GitPython
export HUGO_ENV=production
python3 .buildpush.py
