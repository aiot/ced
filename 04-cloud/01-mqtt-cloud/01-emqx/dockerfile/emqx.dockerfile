# https://github.com/emqx/emqx/blob/vEMQX_VERSION/deploy/docker/Dockerfile

# get pkg
# https://www.emqx.io/docs/zh/v4.4/getting-started/directory.html
FROM emqx/emqx:EMQX_VERSION AS getpkg

USER 0

RUN \
    set -ex && \
    \
    emqxVersion='EMQX_VERSION' && \
    rm -rfv \
        /opt/emqx/bin/emqx.cmd \
        /opt/emqx/bin/emqx-${emqxVersion} \
        /opt/emqx/bin/emqx_ctl.cmd \
        /opt/emqx/bin/emqx_ctl-${emqxVersion} \
        /opt/emqx/bin/nodetool-${emqxVersion} \
        /opt/emqx/bin/cuttlefish-${emqxVersion} \
        /opt/emqx/bin/install_upgrade.escript-${emqxVersion} && \
    ln -sfv /opt/emqx/bin/emqx /opt/emqx/bin/emqx-${emqxVersion} && \
    mv -fv /opt/emqx/bin/emqx_ctl /opt/emqx/bin/emqx-ctl && \
    ln -sfv /opt/emqx/bin/emqx-ctl /opt/emqx/bin/emqx_ctl && \
    ln -sfv /opt/emqx/bin/emqx-ctl /opt/emqx/bin/emqx_ctl-${emqxVersion} && \
    ln -sfv /opt/emqx/bin/nodetool /opt/emqx/bin/nodetool-${emqxVersion} && \
    mv -fv /opt/emqx/bin/node_dump /opt/emqx/bin/node-dump && \
    ln -sfv /opt/emqx/bin/node-dump /opt/emqx/bin/node_dump && \
    ln -sfv /opt/emqx/bin/cuttlefish /opt/emqx/bin/cuttlefish-${emqxVersion} && \
    mv -fv /opt/emqx/bin/install_upgrade.escript /opt/emqx/bin/install-upgrade.escript && \
    ln -sfv /opt/emqx/bin/install-upgrade.escript /opt/emqx/bin/install_upgrade.escript && \
    ln -sfv /opt/emqx/bin/install-upgrade.escript /opt/emqx/bin/install_upgrade.escript-${emqxVersion} && \
    rm -rfv /opt/emqx/etc/certs && \
    mkdir -p -v /opt/emqx/etc/pki/ && \
    ln -sfv /opt/emqx/etc/pki /opt/emqx/etc/certs && \
    chown -R root:root /opt/emqx/


# build image
FROM {{kubefactory.domain.public.free}}/{{kubefactory.infraImage.repository}}/alpine:ALPINE_VERSION

# ENV \
#     CUTTLEFISH_ENV_OVERRIDE_PREFIX='EMQX_'

WORKDIR /opt/emqx/

COPY \
    --from='getpkg' /opt/emqx/ /opt/emqx/

RUN \
    set -ex && \
    \
    apk update --allow-untrusted --purge --no-cache && \
    apk add --allow-untrusted --upgrade --no-cache openssl ncurses-libs libstdc++ && \
    rm -rfv /var/cache/apk/* && \
    \
    ln -sfv /opt/emqx/bin/* /usr/local/bin/

# ENTRYPOINT ["/bin/bash", "-c", "/opt/emqx/bin/emqx foreground"]
CMD ["/bin/bash", "-c", "/opt/emqx/bin/emqx foreground"]
