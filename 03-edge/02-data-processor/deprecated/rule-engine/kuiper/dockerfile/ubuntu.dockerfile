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
        pkg-config libczmq-dev sqlite3 && \
    apt autoremove -y && \
    rm -rfv /var/lib/apt/lists/* && \
    \
    kuiperVersion='KUIPER_VERSION' && \
    cd $(go env GOPATH) && \
    git clone --recurse --tags https://github.com/lf-edge/ekuiper.git && \
    mv -fv ekuiper kuiper && cd kuiper && \
    git checkout ${kuiperVersion} && \
        make build_with_edgex && \
        mv -fv _build/kuiper-${kuiperVersion}-linux-amd64 _build/kuiper && \
        # CGO_ENABLED="1" go build -trimpath -modfile extensions.mod --buildmode=plugin -v -o _build/kuiper/plugins/sources/zmq.so extensions/sources/zmq/zmq.go && \
        # go build -trimpath -modfile extensions.mod --buildmode=plugin -v -o _build/kuiper/plugins/sources/random.so extensions/sources/random/random.go && \
        # CGO_ENABLED="1" go build -trimpath -modfile extensions.mod --buildmode=plugin -v -o _build/kuiper/plugins/sinks/zmq.so extensions/sinks/zmq/zmq.go && \
        # go build -trimpath -modfile extensions.mod --buildmode=plugin -v -o _build/kuiper/plugins/sinks/file.so extensions/sinks/file/file.go && \
        # go build -trimpath -modfile extensions.mod --buildmode=plugin -v -o _build/kuiper/plugins/sinks/image.so extensions/sinks/image/image.go && \
        # go build -trimpath -modfile extensions.mod --buildmode=plugin -v -o _build/kuiper/plugins/sinks/tdengine@v{{kubethings.aiot.cloud.tdengine.version}}.so extensions/sinks/tdengine/tdengine.go && \
    rm -rfv _build/kuiper/etc/mgmt/* && \
    openssl genrsa -out _build/kuiper/etc/mgmt/jwt.key 2048 && \
    openssl rsa -in _build/kuiper/etc/mgmt/jwt.key -pubout -out _build/kuiper/etc/mgmt/jwt.pub


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
        pkg-config sqlite3 libczmq-dev && \
    apt autoremove -y && \
    rm -rfv /var/lib/apt/lists/*

# ENTRYPOINT ["/bin/bash", "-c", "${KUIPER_HOME}/bin/kuiperd --help"]
CMD ["/bin/bash", "-c", "${KUIPER_HOME}/bin/kuiperd --help"]
