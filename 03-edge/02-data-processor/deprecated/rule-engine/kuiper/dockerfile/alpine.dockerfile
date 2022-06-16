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
        git gcc make libc-dev binutils-gold pkgconfig sqlite zeromq-dev && \
    rm -rfv /var/cache/apk/* && \
    \
    kuiperVersion='KUIPER_VERSION' && \
    cd $(go env GOPATH) && \
    git clone --recurse --tags https://github.com/lf-edge/ekuiper.git && \
    mv -fv ekuiper kuiper && cd kuiper && \
    git checkout ${kuiperVersion} && \
        # https://ekuiper.org/docs/zh/latest/features.html
        # CGO_ENABLE="1" must be set, because kuiper depends on sqlite, for more details see https://ekuiper.org/docs/zh/latest/operation/compile/cross-compile.html
        # https://github.com/lf-edge/ekuiper/blob/${kuiperVersion}/Makefile#L50
        make build_with_edgex && \
        mv -fv _build/kuiper-${kuiperVersion}-linux-amd64 _build/kuiper && \
        # # https://ekuiper.org/docs/zh/latest/rules/sinks/plugin/tdengine.html
        # go build -trimpath -modfile extensions.mod --buildmode=plugin -v -o _build/kuiper/plugins/sinks/tdengine@v{{kubethings.aiot.cloud.tdengine.version}}.so extensions/sinks/tdengine/tdengine.go && \
        # https://ekuiper.org/docs/zh/latest/rules/sinks/plugin/file.html
        go build -trimpath -modfile extensions.mod --buildmode=plugin -v -o _build/kuiper/plugins/sinks/file.so extensions/sinks/file/file.go && \
        # https://ekuiper.org/docs/zh/latest/rules/sinks/plugin/image.html
        go build -trimpath -modfile extensions.mod --buildmode=plugin -v -o _build/kuiper/plugins/sinks/image.so extensions/sinks/image/image.go


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
        sqlite libzmq && \
    rm -rfv /var/cache/apk/*

# ENTRYPOINT ["/bin/bash", "-c", "${KUIPER_HOME}/bin/kuiperd --help"]
CMD ["/bin/bash", "-c", "${KUIPER_HOME}/bin/kuiperd --help"]
