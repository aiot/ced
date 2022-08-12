#!/usr/bin/env bash

emqxVersion='{{kubethings.aiot.cloud.emqx.version}}'
emqxOperatorVersion='{{kubethings.aiot.cloud.emqx.operator.version}}'
alpineVersion='{{kubefactory.infraImage.alpine.version}}'
ubuntuVersion='{{kubefactory.infraImage.ubuntu.version}}'
imageRepository='{{kubethings.image.repository}}'

function buildImage() {
    sed --in-place \
        --expression="s/EMQX_VERSION/${emqxVersion}/g" \
        --expression="s/EMQX_OPERATOR_VERSION/${emqxOperatorVersion}/g" \
        --expression="s/ALPINE_VERSION/${alpineVersion}/g" \
        --expression="s/UBUNTU_VERSION/${ubuntuVersion}/g" \
        $1

    docker build --pull --file="$1" --tag="$2" .
    if [[ $? != 0 ]]
    then
        exit 1
    fi

    docker push $2
    docker rmi $2
}


# build emqx image
buildImage emqx.dockerfile ${imageRepository}/emqx:${emqxVersion}
docker rmi emqx/emqx:${emqxVersion}


# # build emqx-edge image
# buildImage emqx-edge.dockerfile ${imageRepository}/emqx-edge:${emqxVersion}
# docker rmi emqx/emqx-edge:${emqxVersion}


# build emqx-operator image
buildImage operator.dockerfile ${imageRepository}/emqx-operator:${emqxOperatorVersion}
docker rmi emqx/emqx-operator-controller:${emqxOperatorVersion}


#
docker rmi {{kubefactory.domain.public.free}}/{{kubefactory.infraImage.repository}}/alpine:${alpineVersion} || true
docker rmi {{kubefactory.domain.public.free}}/{{kubefactory.infraImage.repository}}/ubuntu:${ubuntuVersion} || true
