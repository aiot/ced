#!/usr/bin/env bash

kuiperVersion='{{kubethings.aiot.edge.kuiper.version}}'
alpineVersion='{{kubefactory.infraImage.alpine.version}}'
ubuntuVersion='{{kubefactory.infraImage.ubuntu.version}}'
imageRepository='{{kubethings.image.repository}}'

function buildImage() {
    sed --in-place \
        --expression="s/KUIPER_VERSION/${kuiperVersion}/g" \
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


# build kuiper image
buildImage alpine.dockerfile ${imageRepository}/kuiper:${kuiperVersion}
docker rmi golang:1.17-alpine
# docker rmi lfedge/ekuiper:${kuiperVersion}-alpine


# # build kuiper-ubuntu image
# buildImage ubuntu.dockerfile ${imageRepository}/kuiper-ubuntu:${kuiperVersion}-${ubuntuVersion}
# docker rmi golang:1.17
# # docker rmi lfedge/ekuiper:${kuiperVersion}-slim


# build kuiper-manager image
buildImage dashboard.dockerfile ${imageRepository}/kuiper-manager:${kuiperVersion}
docker rmi emqx/ekuiper-manager:${kuiperVersion}


#
docker rmi {{kubefactory.domain.public.free}}/{{kubefactory.infraImage.repository}}/alpine:${alpineVersion} || true
docker rmi {{kubefactory.domain.public.free}}/{{kubefactory.infraImage.repository}}/ubuntu:${ubuntuVersion} || true
