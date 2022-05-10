# https://github.com/emqx/emqx-operator/blob/EMQX_OPERATOR_VERSION/Dockerfile

# get bin
FROM emqx/emqx-operator-controller:EMQX_OPERATOR_VERSION AS getbin

# chown
FROM {{kubefactory.domain.public.free}}/{{kubefactory.infraImage.repository}}/alpine:ALPINE_VERSION AS getbin-chown

COPY \
    --from='getbin' /manager /usr/local/bin/emqx-operator

RUN \
    set -ex && \
    \
    chown -v root:root /usr/local/bin/emqx-operator && \
    chmod -v 755 /usr/local/bin/emqx-operator


# build image
FROM {{kubefactory.domain.public.free}}/{{kubefactory.infraImage.repository}}/alpine:ALPINE_VERSION

COPY \
    --from='getbin-chown' /usr/local/bin/emqx-operator /usr/local/bin/

# ENTRYPOINT ["/bin/bash", "-c", "/usr/local/bin/emqx-operator --help"]
CMD ["/bin/bash", "-c", "/usr/local/bin/emqx-operator --help"]
