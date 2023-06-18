#! /bin/sh

apk add git python3 py3-gitpython openssh-client

mkdir ~/.ssh
chmod 700 ~/.ssh

echo "Setting Host Keys for GitLab...."
echo '[git.baalajimaestro.me]:29999 ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC3IrYRuprw3liGd+/EGLBFqxQ9S2+/1FNxNCpO87wjRIpDxZjAWOvT2tUoIEUzWEGNHqkgRLn+rR0hsGK0SqHIPyEIsJ5AKuS7zuhy6fkVS7RsDHjJ8usBF4j3EnkYBse5qLgUIf37u0mF0EXAFcuwOBgvXM6hqL0UYcQqRGWWrHvkRRcmizkAcxJcframf3+PLG/vn4fSUH7ZUUqjx6/QIJS0iFb0HB2mv8sWzpJlJmy46WZVltwPDLOLeGZb4OcAB20/yfPalb4MsQeSrVmYtRos3sN8Uh/DwfNT/u5Jk6qqXHm3GW2fzsbZInb+0XjrmdaH3awhUN0vQMDvYgvR2UcZHgRuJvKXMAo3keOA8m9cBXJvopr/TyKt4GUvIGzjXUB9kyW/sIxn6qJel8y3b486FxV1EI2m9wKzFbtRdRG1xWxjTR16LyerrzwgAaAayFxyuQ6UgvM4zCzdgk6cDT2hGfHhF2NUKiWDobGowQJairVCzaYZCT/jy9avm2M=' >> ~/.ssh/known_hosts
echo '[git.baalajimaestro.me]:29999 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBL0yV054Ox/OPWCAz6hzo6VKkugDJx7ziCQBAdjhWfTTK3YCYroPANtflimBZYNhl43OyUx0mbdh8W27+T/PXBU=' >> ~/.ssh/known_hosts
echo '[git.baalajimaestro.me]:29999 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHJWhNlVfjAqfnHGqtqudlRZ8IBD8gt2XJUvBBAI6+5K' >> ~/.ssh/known_hosts

git config --global user.name baalajimaestro
git config --global user.email me@baalajimaestro.me

export HUGO_ENV=production

python3 .buildpush.py
