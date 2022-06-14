# https://github.com/lf-edge/ekuiper/blob/KUIPER_VERSION/deploy/docker/Dockerfile-alpine

# build bin
FROM golang:1.17-alpine AS builder

ENV \
    CHARSET='UTF-8' \
    LANG='C.UTF-8' \
    LANGUAGE='C.UTF-8' \
    LC_ALL='C.UTF-8' \
    \
    GOBIN="${GOPATH}/bin" \
    CGO_ENABLED="0"

RUN \
    set -ex && \
    \
    apk update --allow-untrusted --purge --no-cache && \
    apk add --allow-untrusted --upgrade --no-cache \
        git gcc make libc-dev binutils-gold pkgconfig zeromq-dev && \
    rm -rfv /var/cache/apk/* && \
    \
    kuiperVersion='KUIPER_VERSION' && \
    cd $(go env GOPATH) && \
    git clone --recurse --tags https://github.com/lf-edge/ekuiper.git && \
    cd ekuiper && \
    git checkout ${kuiperVersion} && \
        make build_with_edgex && \
        mv -fv _build/kuiper-${kuiperVersion}-linux-amd64 _build/kuiper


# build image
FROM {{kubefactory.domain.public.free}}/{{kubefactory.infraImage.repository}}/alpine:ALPINE_VERSION

ARG kuiperHome='/usr/local/kuiper'
ENV \
    KUIPER_HOME="${kuiperHome}" \
    KUIPER__BASIC__CONSOLELOG=true

WORKDIR ${kuiperHome}

COPY \
    --from='builder' /go/kuiper/_build/kuiper/ ${kuiperHome}/

RUN \
    set -ex && \
    \
    apk update --allow-untrusted --purge --no-cache && \
    apk add --allow-untrusted --upgrade --no-cache \
        libzmq && \
    rm -rfv /var/cache/apk/*

# ENTRYPOINT ["/bin/bash", "-c", "${KUIPER_HOME}/bin/kuiperd --help"]
CMD ["/bin/bash", "-c", "${KUIPER_HOME}/bin/kuiperd --help"]
