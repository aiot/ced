# https://github.com/emqx/nanomq/blob/NANOMQ_VERSION/deploy/docker/Dockerfile-slim

# build bin
FROM {{kubefactory.domain.public.free}}/{{kubefactory.infraImage.repository}}/ubuntu:UBUNTU_VERSION AS builder

RUN \
    set -ex && \
    \
    apt update -y && \
    # install git
    apt install -y --no-install-recommends git openssh-client && \
    # install build dependence
    apt install -y --no-install-recommends gcc g++ cmake ninja-build libmbedtls-dev sqlite && \
    \
    apt autoremove -y && \
    rm -rfv /var/lib/apt/lists/* && \
    \
    # build bin
    # https://github.com/emqx/nanomq/blob/NANOMQ_VERSION/README.md#compile--install
    # https://nanomq.io/docs/zh/latest/quick-start.html
    # https://nanomq.io/docs/zh/latest/build-options.html
    cd /root/ && \
    git clone --recurse --tags https://github.com/emqx/nanomq.git && \
    cd nanomq/ && \
    git checkout NANOMQ_VERSION && \
        mkdir -p -v build && \
        cd build && \
        cmake -G Ninja -DENABLE_JWT=OFF -DNNG_ENABLE_TLS=ON -DNNG_ENABLE_SQLITE=ON -DNOLOG=1 .. && \
        ninja install && \
    chown -v root:root /root/nanomq/build/nanomq/nanomq && \
    chmod -v 755 /root/nanomq/build/nanomq/nanomq

# build image
FROM {{kubefactory.domain.public.free}}/{{kubefactory.infraImage.repository}}/ubuntu:UBUNTU_VERSION

COPY \
    --from='builder' /root/nanomq/build/nanomq/nanomq /usr/local/bin/

RUN \
    set -ex && \
    \
    apt update -y && \
    apt install -y --no-install-recommends libatomic1 libmbedtls-dev sqlite && \
    apt autoremove -y && \
    rm -rfv /var/lib/apt/lists/*

# ENTRYPOINT ["/bin/bash", "-c", "/usr/local/bin/nanomq broker --help"]
CMD ["/bin/bash", "-c", "/usr/local/bin/nanomq broker --help"]
