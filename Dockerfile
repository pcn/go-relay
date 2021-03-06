FROM alpine:3.4

MAINTAINER Kevin Smith <kevin@operable.io>

ARG GIT_COMMIT
ENV GIT_COMMIT ${GIT_COMMIT:-master}

# Bake in a directory that we can use for logging, config, etc.
RUN mkdir -p /var/operable/relay

RUN mkdir -p /root/golang/src/github.com/operable/ && \
  cd /root/golang/src/github.com/operable && \
  apk add -U --no-cache git go make ca-certificates && \
  git clone https://github.com/operable/go-relay && \
  cd go-relay && git checkout $GIT_COMMIT && \
  GOPATH=/root/golang make exe && \
  cp _build/relay /usr/local/bin && \
  mkdir -p /usr/local/etc && \
  cp docker/relay.conf /usr/local/etc/relay.conf && \
  cd /root && rm -rf golang && \
  apk del --force --rdepends --purge go make git && rm -rf /var/cache/apk/*
