#!/usr/bin/env bash

# get the absolute path of this file
relativePath=$0
if [[ ${relativePath:0:1} == '/' ]]
then
    absolutePath=$(dirname ${relativePath})
else
    absolutePath=$(pwd)/$(dirname ${relativePath})
fi

# delete
# # bug: kubectl's kustomize yaml-render has bug, so do not use `delete -k`
# kubectl delete -k ${absolutePath}/ --ignore-not-found=true
for yamlName in $(yq --output-format=json --indent=4 ${absolutePath}/kustomization.yaml | jq -r '.resources[]')
do
    kubectl delete -f ${absolutePath}/${yamlName} --ignore-not-found=true
done

# prune
appNamespace='aiot-case'

certAll=(
    'emqx-ca'
    'emqx-cert'

    'emqx-client-cert-cloud-app'
    'emqx-client-cert-edge-app'
    'emqx-client-cert-mqtt-edge'
    'emqx-client-cert-mqttx'
)
for cert in ${certAll[*]}
do
    kubectl delete secret -n ${appNamespace} ${cert} --ignore-not-found=true
done
