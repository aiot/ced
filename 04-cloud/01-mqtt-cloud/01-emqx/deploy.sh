#!/usr/bin/env bash

# get the absolute path of this file
relativePath=$0
if [[ ${relativePath:0:1} == '/' ]]
then
    absolutePath=$(dirname ${relativePath})
else
    absolutePath=$(pwd)/$(dirname ${relativePath})
fi


# apply crd
kubectl apply -f ${absolutePath}/yaml/01-crd.yaml

emqxOperatorCRDTypeAll=(
    'emqxbrokers.apps.emqx.io'
    'emqxenterprises.apps.emqx.io'
)

for emqxOperatorCRDType in ${emqxOperatorCRDTypeAll[*]}
do
    until kubectl get crd -o name ${emqxOperatorCRDType} > /dev/null 2>&1
    do
        echo -e "waiting for crd/${emqxOperatorCRDType} to be created ..."
        sleep 1
    done
done

# create namespace
appNamespace='{{kubethings.namespace}}'
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
