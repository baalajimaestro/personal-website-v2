FROM equalos/hugo:extended-alpine

RUN apk update && apk add curl git go

RUN git config --global user.email "me@baalajimaestro.me" && \
    git config --global user.name "baalajimaestro" && \
    git config --global init.defaultBranch "master"

COPY push.sh /root

WORKDIR /app

ENTRYPOINT ["/usr/bin/env"]
CMD ["sh", "/root/push.sh"]