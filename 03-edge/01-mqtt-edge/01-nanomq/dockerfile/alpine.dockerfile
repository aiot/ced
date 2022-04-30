# https://github.com/emqx/nanomq/blob/NANOMQ_VERSION/deploy/docker/Dockerfile-alpine

# build bin
FROM {{kubefactory.domain.public.free}}/{{kubefactory.infraImage.repository}}/alpine:ALPINE_VERSION AS builder

RUN \
    set -ex && \
    \
    apk update --allow-untrusted --purge --no-cache && \
    # install git
    apk add --allow-untrusted --upgrade --no-cache git openssh-client && \
    # install build dependence
    apk add --allow-untrusted --upgrade --no-cache gcc g++ cmake ninja mbedtls-dev && \
    \
    rm -rfv /var/cache/apk/* && \
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
        cmake -G Ninja -DNNG_ENABLE_TLS=ON -DNOLOG=1 .. && \
        ninja install && \
    chown -v root:root /usr/lib/libgcc_s.so.1 /root/nanomq/build/nanolib/libnano_shared.so /usr/local/bin/nanomq && \
    chmod -v 755 /root/nanomq/build/nanolib/libnano_shared.so /usr/local/bin/nanomq


# build image
FROM {{kubefactory.domain.public.free}}/{{kubefactory.infraImage.repository}}/alpine:ALPINE_VERSION

RUN \
    set -ex && \
    \
    apk update --allow-untrusted --purge --no-cache && \
    apk add --allow-untrusted --upgrade --no-cache mbedtls-dev && \
    rm -rfv /var/cache/apk/*

COPY \
    --from='builder' /usr/lib/libgcc_s.so.1 /usr/lib/
COPY \
    --from='builder' /root/nanomq/build/nanolib/libnano_shared.so /usr/lib/
COPY \
    --from='builder' /usr/local/bin/nanomq /usr/local/bin/

# ENTRYPOINT ["/bin/bash", "-c", "/usr/local/bin/nanomq broker --help"]
CMD ["/bin/bash", "-c", "/usr/local/bin/nanomq broker --help"]
