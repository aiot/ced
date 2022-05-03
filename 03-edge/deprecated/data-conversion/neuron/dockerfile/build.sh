#!/usr/bin/env bash

neuronVersion='{{kubethings.aiot.edge.neuron.version}}'
alpineVersion='{{kubefactory.infraImage.alpine.version}}'
ubuntuVersion='{{kubefactory.infraImage.ubuntu.version}}'
imageRepository='{{kubethings.image.repository}}'

buildImage() {
    sed --in-place \
        --expression="s/NEURON_VERSION/${neuronVersion}/g" \
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


# build neuron image
buildImage alpine.dockerfile ${imageRepository}/neuron:${neuronVersion}


# build neuron-ubuntu image
buildImage ubuntu.dockerfile ${imageRepository}/neuron-ubuntu:${neuronVersion}-${ubuntuVersion}


#
docker rmi neugates/neuron:${neuronVersion}

docker rmi {{kubefactory.domain.public.free}}/{{kubefactory.infraImage.repository}}/alpine:${alpineVersion} || true
docker rmi {{kubefactory.domain.public.free}}/{{kubefactory.infraImage.repository}}/ubuntu:${ubuntuVersion} || true
