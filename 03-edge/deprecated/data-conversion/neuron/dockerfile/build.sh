#!/usr/bin/env bash

neuronVersion='{{kubethings.aiot.edge.neuron.version}}'
alpineVersion='{{kubefactory.infraImage.alpine.version}}'
ubuntuVersion='{{kubefactory.infraImage.ubuntu.version}}'
imageRepository='{{kubethings.image.repository}}'


# build neuron image
sed --in-place \
    --expression="s/NEURON_VERSION/${neuronVersion}/g" \
    --expression="s/ALPINE_VERSION/${alpineVersion}/g" \
    --expression="s/UBUNTU_VERSION/${ubuntuVersion}/g" \
    alpine.dockerfile

docker build --pull --file='alpine.dockerfile' --tag="${imageRepository}/neuron:${neuronVersion}" .
if [[ $? != 0 ]]
then
    exit 1
fi

docker push ${imageRepository}/neuron:${neuronVersion}

docker rmi ${imageRepository}/neuron:${neuronVersion}


# build neuron-ubuntu image
sed --in-place \
    --expression="s/NEURON_VERSION/${neuronVersion}/g" \
    --expression="s/ALPINE_VERSION/${alpineVersion}/g" \
    --expression="s/UBUNTU_VERSION/${ubuntuVersion}/g" \
    ubuntu.dockerfile

docker build --pull --file='ubuntu.dockerfile' --tag="${imageRepository}/neuron-ubuntu:${neuronVersion}-${ubuntuVersion}" .
if [[ $? != 0 ]]
then
    exit 1
fi

docker push ${imageRepository}/neuron-ubuntu:${neuronVersion}-${ubuntuVersion}

docker rmi ${imageRepository}/neuron-ubuntu:${neuronVersion}-${ubuntuVersion}


#
docker rmi neugates/neuron:${neuronVersion}

docker rmi {{kubefactory.domain.public.free}}/{{kubefactory.infraImage.repository}}/alpine:${alpineVersion} || true
docker rmi {{kubefactory.domain.public.free}}/{{kubefactory.infraImage.repository}}/ubuntu:${ubuntuVersion} || true
