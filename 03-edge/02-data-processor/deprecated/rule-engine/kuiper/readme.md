# kuiper

> https://docs.emqx.com/zh/kuiper/latest/ <br/>
https://github.com/lf-edge/ekuiper

## yaml reference

```bash
git clone --recurse --tags git@github.com:lf-edge/ekuiper.git
mv -fv ekuiper kuiper
cd kuiper
git checkout {{kubethings.aiot.edge.kuiper.version}}
cd deploy/chart

helm template kuiper \
    --include-crds \
    --namespace aiot-case \
    --name-template kuiper \
    --set persistence.enabled=false \
    --set replicaCount='1' > kuiper.yaml
```

# kuiper-ui

> warning: kuiper-manager is not open source: https://hub.docker.com/r/emqx/ekuiper-manager
