# https://github.com/emqx/emqx/blob/vEMQX_VERSION/deploy/docker/Dockerfile
# https://github.com/emqx/emqx/blob/vEMQX_VERSION/deploy/docker/Dockerfile.alpine

# get pkg
# https://www.emqx.io/docs/zh/v4.4/getting-started/directory.html
FROM emqx/emqx:EMQX_VERSION AS getpkg

USER 0

ARG emqxHome='/opt/emqx'
ENV \
    EMQX_HOME="${emqxHome}"

RUN \
    set -ex && \
    \
    emqxVersion='EMQX_VERSION' && \
    \
    chown -R root:root ${emqxHome}/ && \
    rm -rfv emqx-${emqxVersion}.tar.gz || true && \
    \
    cd ${emqxHome}/bin/ && \
    rm -rfv \
        emqx-${emqxVersion} \
        emqx.cmd \
        emqx_ctl-${emqxVersion} \
        emqx_ctl.cmd \
        nodetool-${emqxVersion} \
        install_upgrade.escript-${emqxVersion} && \
    ln -sfv emqx emqx-${emqxVersion} && \
    mv -fv emqx_ctl emqx-ctl && \
    ln -sfv emqx-ctl emqx_ctl && \
    ln -sfv emqx-ctl emqx_ctl-${emqxVersion} && \
    ln -sfv nodetool nodetool-${emqxVersion} && \
    mv -fv node_dump node-dump && \
    ln -sfv node-dump node_dump && \
    mv -fv install_upgrade.escript install-upgrade.escript && \
    ln -sfv install-upgrade.escript install_upgrade.escript && \
    ln -sfv install-upgrade.escript install_upgrade.escript-${emqxVersion} && \
    \
    cd ${emqxHome}/etc/ && \
    mkdir -p -v conf.d/ && \
    mv -fv emqx-example-en.conf emqx.default.conf && \
    rm -rfv certs && \
    mkdir -p -v pki/ pki/jwt/ && \
    ln -sfv pki certs


# build image
FROM {{kubefactory.domain.public.free}}/{{kubefactory.infraImage.repository}}/alpine:ALPINE_VERSION

ARG emqxHome='/opt/emqx'
ENV \
    # HOCON_ENV_OVERRIDE_PREFIX='EMQX_' \
    EMQX_HOME="${emqxHome}"

WORKDIR ${emqxHome}/

COPY \
    --from='getpkg' /opt/emqx/ ${emqxHome}/

RUN \
    set -ex && \
    \
    apk update --allow-untrusted --purge --no-cache && \
    apk add --allow-untrusted --upgrade --no-cache openssl ncurses-libs libstdc++ && \
    rm -rfv /var/cache/apk/* && \
    \
    ln -sfv ${emqxHome}/bin/* /usr/local/bin/

# ENTRYPOINT ["/bin/bash", "-c", "${EMQX_HOME}/bin/emqx foreground"]
CMD ["/bin/bash", "-c", "${EMQX_HOME}/bin/emqx foreground"]
