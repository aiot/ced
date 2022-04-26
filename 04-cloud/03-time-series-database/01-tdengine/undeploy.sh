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
kubectl delete -f ${absolutePath}/yaml/01-crd.yaml --ignore-not-found=true

# prune
appNamespace='{{kubestore.namespace}}'

configAll=(
    ''
)
for config in ${configAll[*]}
do
    kubectl delete configmap -n ${appNamespace} ${config} --ignore-not-found=true
done

certAll=(
    'tdengine-operator-ca'
    'tdengine-operator-cert'
)
for cert in ${certAll[*]}
do
    kubectl delete secret -n ${appNamespace} ${cert} --ignore-not-found=true
done
