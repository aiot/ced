#!/usr/bin/env bash

nanomqVersion='{{kubethings.aiot.edge.nanomq.app.version}}'
alpineVersion='{{kubefactory.infraImage.alpine.version}}'
ubuntuVersion='{{kubefactory.infraImage.ubuntu.version}}'
imageRepository='{{kubestore.image.repository}}'


# build nanomq image
sed --in-place \
    --expression="s/NANOMQ_VERSION/${nanomqVersion}/g" \
    --expression="s/ALPINE_VERSION/${alpineVersion}/g" \
    --expression="s/UBUNTU_VERSION/${ubuntuVersion}/g" \
    alpine.dockerfile

docker build --pull --file='alpine.dockerfile' --tag="${imageRepository}/nanomq:${nanomqVersion}" .
if [[ $? != 0 ]]
then
    exit 1
fi

docker push ${imageRepository}/nanomq:${nanomqVersion}

# docker rmi nanomq/nanomq:${nanomqVersion}-alpine
docker rmi ${imageRepository}/nanomq:${nanomqVersion}


# build nanomq-ubuntu image
sed --in-place \
    --expression="s/NANOMQ_VERSION/${nanomqVersion}/g" \
    --expression="s/ALPINE_VERSION/${alpineVersion}/g" \
    --expression="s/UBUNTU_VERSION/${ubuntuVersion}/g" \
    ubuntu.dockerfile

docker build --pull --file='ubuntu.dockerfile' --tag="${imageRepository}/nanomq-ubuntu:${nanomqVersion}-${ubuntuVersion}" .
if [[ $? != 0 ]]
then
    exit 1
fi

docker push ${imageRepository}/nanomq-ubuntu:${nanomqVersion}-${ubuntuVersion}

# docker rmi nanomq/nanomq:${nanomqVersion}-slim
docker rmi ${imageRepository}/nanomq-ubuntu:${nanomqVersion}-${ubuntuVersion}


#
docker rmi {{kubefactory.domain.public.free}}/{{kubefactory.infraImage.repository}}/alpine:${alpineVersion} || true
docker rmi {{kubefactory.domain.public.free}}/{{kubefactory.infraImage.repository}}/ubuntu:${ubuntuVersion} || true
