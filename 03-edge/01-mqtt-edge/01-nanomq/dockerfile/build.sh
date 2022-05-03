#!/usr/bin/env bash

nanomqVersion='{{kubethings.aiot.edge.nanomq.version}}'
alpineVersion='{{kubefactory.infraImage.alpine.version}}'
ubuntuVersion='{{kubefactory.infraImage.ubuntu.version}}'
imageRepository='{{kubethings.image.repository}}'

buildImage() {
    sed --in-place \
        --expression="s/NANOMQ_VERSION/${nanomqVersion}/g" \
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


# build nanomq image
buildImage alpine.dockerfile ${imageRepository}/nanomq:${nanomqVersion}
# docker rmi nanomq/nanomq:${nanomqVersion}-alpine


# build nanomq debug image
cp -rfv alpine.dockerfile alpine.debug.dockerfile
sed -i 's/DNOLOG=1/DNOLOG=0/g' /etc/bash_completion.d/ccli
buildImage alpine.debug.dockerfile ${imageRepository}/nanomq:${nanomqVersion}-debug
# docker rmi nanomq/nanomq:${nanomqVersion}-alpine


# # build nanomq-ubuntu image
# buildImage ubuntu.dockerfile ${imageRepository}/nanomq-ubuntu:${nanomqVersion}-${ubuntuVersion}
# # docker rmi nanomq/nanomq:${nanomqVersion}-slim


#
docker rmi {{kubefactory.domain.public.free}}/{{kubefactory.infraImage.repository}}/alpine:${alpineVersion} || true
docker rmi {{kubefactory.domain.public.free}}/{{kubefactory.infraImage.repository}}/ubuntu:${ubuntuVersion} || true
