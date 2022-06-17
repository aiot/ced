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

## stream: 数据流

1. source: `输入`

    > https://ekuiper.org/docs/zh/latest/concepts/sources/overview.html

    - mqtt

    - zeromq

    - http-get

    - file

    - neuron

    - edgex

2. rule(based on sql and function): `计算`

    > https://ekuiper.org/docs/zh/latest/concepts/rules.html

    - sql: 查询

        > https://ekuiper.org/docs/zh/latest/concepts/sql.html

    - action: 业务逻辑

        - function: 内置函数

        - extension: 扩展

3. sink: `输出`

    > https://ekuiper.org/docs/zh/latest/concepts/sinks.html

    - 控制数据

        - mqtt

        - zeromq

        - neuron

        - edgex

    - 状态数据

        - http-post

        - database

        - file

        - log

## api

### http

#### ui

> warning: kuiper-manager is not open source: https://hub.docker.com/r/emqx/ekuiper-manager

### cli
