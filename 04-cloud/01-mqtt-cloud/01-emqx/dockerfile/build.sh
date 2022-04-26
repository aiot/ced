#!/usr/bin/env bash

emqxVersion='{{kubethings.aiot.cloud.emqx.app.version}}'
emqxOperatorVersion='{{kubethings.aiot.cloud.emqx.version}}'
alpineVersion='{{kubefactory.infraImage.alpine.version}}'
ubuntuVersion='{{kubefactory.infraImage.ubuntu.version}}'
imageRepository='{{kubestore.image.repository}}'


# build emqx-operator image
sed --in-place \
    --expression="s/EMQX_OPERATOR_VERSION/${emqxOperatorVersion}/g" \
    --expression="s/ALPINE_VERSION/${alpineVersion}/g" \
    --expression="s/UBUNTU_VERSION/${ubuntuVersion}/g" \
    operator.dockerfile

docker build --pull --file='operator.dockerfile' --tag="${imageRepository}/emqx-operator:${emqxOperatorVersion}" .
if [[ $? != 0 ]]
then
    exit 1
fi

docker push ${imageRepository}/emqx-operator:${emqxOperatorVersion}

docker rmi emqx/emqx-operator-controller:${emqxOperatorVersion}
docker rmi ${imageRepository}/emqx-operator:${emqxOperatorVersion}


# build emqx image
sed --in-place \
    --expression="s/EMQX_VERSION/${emqxVersion}/g" \
    --expression="s/ALPINE_VERSION/${alpineVersion}/g" \
    --expression="s/UBUNTU_VERSION/${ubuntuVersion}/g" \
    emqx.dockerfile

docker build --pull --file='emqx.dockerfile' --tag="${imageRepository}/emqx:${emqxVersion}" .
if [[ $? != 0 ]]
then
    exit 1
fi

docker push ${imageRepository}/emqx:${emqxVersion}

docker rmi emqx/emqx:${emqxVersion}
docker rmi ${imageRepository}/emqx:${emqxVersion}


# # build emqx-edge image
# sed --in-place \
#     --expression="s/EMQX_EDGE_VERSION/${emqxEdgeVersion}/g" \
#     --expression="s/ALPINE_VERSION/${alpineVersion}/g" \
#     --expression="s/UBUNTU_VERSION/${ubuntuVersion}/g" \
#     emqx-edge.dockerfile

# docker build --pull --file='emqx-edge.dockerfile' --tag="${imageRepository}/emqx-edge:${emqxEdgeVersion}" .
# if [[ $? != 0 ]]
# then
#     exit 1
# fi

# docker push ${imageRepository}/emqx-edge:${emqxEdgeVersion}

# docker rmi emqx/emqx-edge:${emqxEdgeVersion}
# docker rmi ${imageRepository}/emqx-edge:${emqxEdgeVersion}


#
docker rmi {{kubefactory.domain.public.free}}/{{kubefactory.infraImage.repository}}/alpine:${alpineVersion} || true
docker rmi {{kubefactory.domain.public.free}}/{{kubefactory.infraImage.repository}}/ubuntu:${ubuntuVersion} || true
