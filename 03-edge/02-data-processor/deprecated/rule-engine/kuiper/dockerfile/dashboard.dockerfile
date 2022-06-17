# get pkg
FROM emqx/ekuiper-manager:{{kubethings.aiot.edge.kuiper.version}} AS getpkg

ENV \
    CHARSET='UTF-8' \
    LANG='C.UTF-8' \
    LANGUAGE='C.UTF-8' \
    LC_ALL='C.UTF-8' \
    DEBIAN_FRONTEND='noninteractive'

USER 0

ARG kuiperManagerHome='/ekuiper-manager'
ENV \
    KUIPER_MANAGER_HOME="${kuiperManagerHome}"

WORKDIR ${kuiperManagerHome}

RUN \
    set -ex && \
    \
    mv -fv ekuiper-manager kuiper-manager && \
    ln -sfv kuiper-manager ekuiper-manager && \
    \
    chown -R root:root ${kuiperManagerHome}/ && \
    chmod -v 755 ${kuiperManagerHome}/kuiper-manager


# build image
FROM {{kubefactory.domain.public.free}}/{{kubefactory.infraImage.repository}}/alpine:ALPINE_VERSION

ARG kuiperManagerHome='/usr/local/kuiper-manager'
ENV \
    KUIPER_MANAGER_HOME="${kuiperManagerHome}"

WORKDIR ${kuiperManagerHome}

COPY \
    --from='getpkg' /ekuiper-manager/ ${kuiperManagerHome}/

# ENTRYPOINT ["/bin/bash", "-c", "${KUIPER_MANAGER_HOME}/kuiper-manager --help"]
CMD ["/bin/bash", "-c", "${KUIPER_MANAGER_HOME}/kuiper-manager --help"]
