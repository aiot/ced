#!/usr/bin/env bash

kuiperVersion='{{kubethings.aiot.edge.kuiper.version}}'
alpineVersion='{{kubefactory.infraImage.alpine.version}}'
ubuntuVersion='{{kubefactory.infraImage.ubuntu.version}}'
imageRepository='{{kubethings.image.repository}}'


# build kuiper image
sed --in-place \
    --expression="s/KUIPER_VERSION/${kuiperVersion}/g" \
    --expression="s/ALPINE_VERSION/${alpineVersion}/g" \
    --expression="s/UBUNTU_VERSION/${ubuntuVersion}/g" \
    alpine.dockerfile

docker build --pull --file='alpine.dockerfile' --tag="${imageRepository}/kuiper:${kuiperVersion}" .
if [[ $? != 0 ]]
then
    exit 1
fi

docker push ${imageRepository}/kuiper:${kuiperVersion}

docker rmi lfedge/ekuiper:${kuiperVersion}-alpine
docker rmi ${imageRepository}/kuiper:${kuiperVersion}


# build kuiper-ubuntu image
sed --in-place \
    --expression="s/KUIPER_VERSION/${kuiperVersion}/g" \
    --expression="s/ALPINE_VERSION/${alpineVersion}/g" \
    --expression="s/UBUNTU_VERSION/${ubuntuVersion}/g" \
    ubuntu.dockerfile

docker build --pull --file='ubuntu.dockerfile' --tag="${imageRepository}/kuiper-ubuntu:${kuiperVersion}-${ubuntuVersion}" .
if [[ $? != 0 ]]
then
    exit 1
fi

docker push ${imageRepository}/kuiper-ubuntu:${kuiperVersion}-${ubuntuVersion}

docker rmi lfedge/ekuiper:${kuiperVersion}-slim
docker rmi ${imageRepository}/kuiper-ubuntu:${kuiperVersion}-${ubuntuVersion}


#
docker rmi {{kubefactory.domain.public.free}}/{{kubefactory.infraImage.repository}}/alpine:${alpineVersion} || true
docker rmi {{kubefactory.domain.public.free}}/{{kubefactory.infraImage.repository}}/ubuntu:${ubuntuVersion} || true
