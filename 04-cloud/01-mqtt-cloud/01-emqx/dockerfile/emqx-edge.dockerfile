# get pkg
# https://www.emqx.io/docs/zh/v4.4/getting-started/directory.html
FROM emqx/emqx-edge:EMQX_VERSION AS getpkg

USER 0

ARG emqxHome='/opt/emqx'
ENV \
    EMQX_HOME="${emqxHome}"

RUN \
    set -ex && \
    \
    emqxVersion='EMQX_VERSION' && \
    \
    cd ${emqxHome}/bin/ && \
    rm -rfv \
        emqx.cmd \
        emqx-${emqxVersion} \
        emqx_ctl.cmd \
        emqx_ctl-${emqxVersion} \
        nodetool-${emqxVersion} \
        cuttlefish-${emqxVersion} \
        install_upgrade.escript-${emqxVersion} && \
    ln -sfv emqx emqx-${emqxVersion} && \
    mv -fv emqx_ctl emqx-ctl && \
    ln -sfv emqx-ctl emqx_ctl && \
    ln -sfv emqx-ctl emqx_ctl-${emqxVersion} && \
    ln -sfv nodetool nodetool-${emqxVersion} && \
    mv -fv node_dump node-dump && \
    ln -sfv node-dump node_dump && \
    ln -sfv cuttlefish cuttlefish-${emqxVersion} && \
    mv -fv install_upgrade.escript install-upgrade.escript && \
    ln -sfv install-upgrade.escript install_upgrade.escript && \
    ln -sfv install-upgrade.escript install_upgrade.escript-${emqxVersion} && \
    \
    cd ${emqxHome}/etc/ && \
    cp -rfv emqx.conf emqx.ref.conf && \
    mkdir -p -v emqx.conf.d/ && \
    rm -rfv certs && \
    mkdir -p -v pki/ pki/jwt/ && \
    ln -sfv pki certs && \
    \
    cd ${emqxHome}/ && \
    chown -R root:root ${emqxHome}/


# build image
FROM {{kubefactory.domain.public.free}}/{{kubefactory.infraImage.repository}}/alpine:ALPINE_VERSION

ARG emqxHome='/opt/emqx'
ENV \
    # CUTTLEFISH_ENV_OVERRIDE_PREFIX='EMQX_' \
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

# ENTRYPOINT ["/bin/bash", "-c", "${emqxHome}/bin/emqx foreground"]
CMD ["/bin/bash", "-c", "${emqxHome}/bin/emqx foreground"]
