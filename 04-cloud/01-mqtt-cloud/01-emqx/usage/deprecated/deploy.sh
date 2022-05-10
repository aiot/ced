#!/usr/bin/env bash

# get the absolute path of this file
relativePath=$0
if [[ ${relativePath:0:1} == '/' ]]
then
    absolutePath=$(dirname ${relativePath})
else
    absolutePath=$(pwd)/$(dirname ${relativePath})
fi


# create namespace
appNamespace='aiot-case'
kubectl get namespace -o name ${appNamespace} > /dev/null 2>&1
if [[ $? != 0 ]]
then
    kubectl create namespace ${appNamespace} --save-config=false
    # kubectl patch serviceaccount -n ${appNamespace} default --patch='{"automountServiceAccountToken": false}'
    # kubectl patch serviceaccount -n ${appNamespace} default --patch='{"imagePullSecrets": [{"name": "{{kubethings.image.pullSecret}}"}]}'
fi

# apply
# # bug: kubectl's kustomize yaml-render has bug, so do not use `apply -k`
# kubectl apply -k ${absolutePath}/
for yamlName in $(yq --output-format=json --indent=4 ${absolutePath}/kustomization.yaml | jq -r '.resources[]')
do
    kubectl apply -f ${absolutePath}/${yamlName}
done


# get cert
certAll=(
    'emqx-client-cert-mqttx'
)
for cert in ${certAll[*]}
do
    clientCertDir="${absolutePath}/client-cert"
    if [[ ! -d ${clientCertDir} ]]
    then
        mkdir -p ${clientCertDir}/
    fi

    until kubectl get secret -n ${appNamespace} -o name ${cert} > /dev/null 2>&1
    do
        echo -e "waiting for secret/${cert} to be created ..."
        sleep 1
    done
    certShortName=$(echo -e ${cert} | awk -F 'emqx-client-cert-' '{print $2}')
    kubectl get secret -n ${appNamespace} -o json ${cert} | jq -r '.data."tls.key"' | base64 --decode --wrap=0 > ${clientCertDir}/${certShortName}.key
    kubectl get secret -n ${appNamespace} -o json ${cert} | jq -r '.data."tls.crt"' | base64 --decode --wrap=0 > ${clientCertDir}/${certShortName}.crt
    kubectl get secret -n ${appNamespace} -o json ${cert} | jq -r '.data."ca.crt"' | base64 --decode --wrap=0 > ${clientCertDir}/ca.crt
done
