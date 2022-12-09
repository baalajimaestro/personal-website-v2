#! /bin/sh

apt update && apt install python3 python3-pip -y
git config --global user.name baalajimaestro
git config --global user.email me@baalajimaestro.me
pip3 install GitPython
export HUGO_ENV=production
python3 .buildpush.py
