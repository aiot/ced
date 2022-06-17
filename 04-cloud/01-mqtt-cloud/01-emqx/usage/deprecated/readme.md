# yaml reference

```bash
git clone --recurse --tags git@github.com:emqx/emqx.git
cd emqx
git checkout --recurse-submodules v{{kubethings.aiot.cloud.emqx.version}}
cd deploy/charts

helm template emqx \
    --include-crds \
    --namespace aiot-case \
    --name-template emqx \
    --set service.type='NodePort' \
    --set persistence.enabled=true > emqx.yaml
```
