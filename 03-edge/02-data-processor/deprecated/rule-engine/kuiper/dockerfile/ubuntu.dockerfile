# https://github.com/lf-edge/ekuiper/blob/KUIPER_VERSION/deploy/docker/Dockerfile-slim

# build bin
FROM golang:1.17 AS builder

ENV \
    CHARSET='UTF-8' \
    LANG='C.UTF-8' \
    LANGUAGE='C.UTF-8' \
    LC_ALL='C.UTF-8' \
    DEBIAN_FRONTEND='noninteractive' \
    \
    GOBIN="${GOPATH}/bin" \
    CGO_ENABLED="0"

RUN \
    set -ex && \
    \
    apt update -y && \
    apt install -y --no-install-recommends \
        ca-certificates apt-transport-https apt-utils \
        pkg-config libczmq-dev && \
    apt autoremove -y && \
    rm -rfv /var/lib/apt/lists/* && \
    \
    kuiperVersion='KUIPER_VERSION' && \
    cd $(go env GOPATH) && \
    git clone --recurse --tags https://github.com/lf-edge/ekuiper.git && \
    mv -fv ekuiper kuiper && cd kuiper && \
    git checkout ${kuiperVersion} && \
        make build_with_edgex && \
        mv -fv _build/kuiper-${kuiperVersion}-linux-amd64 _build/kuiper


# build image
FROM {{kubefactory.domain.public.free}}/{{kubefactory.infraImage.repository}}/ubuntu:UBUNTU_VERSION

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
    apt update -y && \
    apt install -y --no-install-recommends \
        pkg-config libczmq-dev && \
    apt autoremove -y && \
    rm -rfv /var/lib/apt/lists/*

# ENTRYPOINT ["/bin/bash", "-c", "${KUIPER_HOME}/bin/kuiperd --help"]
CMD ["/bin/bash", "-c", "${KUIPER_HOME}/bin/kuiperd --help"]
