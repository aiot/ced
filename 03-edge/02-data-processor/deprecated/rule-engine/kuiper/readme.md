# kuiper

> https://github.com/lf-edge/ekuiper <br/>
https://docs.emqx.com/zh/kuiper/latest/

## yaml reference

```bash
git clone --recurse --tags git@github.com:lf-edge/ekuiper.git
mv -fv ekuiper kuiper
cd kuiper
git checkout --recurse-submodules {{kubethings.aiot.edge.kuiper.version}}
cd deploy/chart

helm template kuiper \
    --include-crds \
    --namespace aiot-case \
    --name-template kuiper \
    --set persistence.enabled=false \
    --set replicaCount='1' > kuiper.yaml
```

## stream and rule: 数据流

1. `输入`: source

    > https://ekuiper.org/docs/zh/latest/concepts/sources/overview.html <br/>
    https://ekuiper.org/docs/zh/latest/rules/sources/overview.html

    - 控制数据

        - mqtt

            > https://ekuiper.org/docs/zh/latest/rules/sources/builtin/mqtt.html

        <strike>

        - zeromq

            > https://ekuiper.org/docs/zh/latest/rules/sources/plugin/zmq.html

        </strike>

        - neuron

            > https://ekuiper.org/docs/zh/latest/rules/sources/builtin/neuron.html

            neuron 与 kuiper 必须运行在同一 edge 上, 因为 kuiper 与 neoron 之间基于 nanomsg ipc 协议通信, 无法通过网络进行

        <strike>

        - edgex

            > https://ekuiper.org/docs/zh/latest/rules/sources/builtin/edgex.html

        </strike>

    <strike>

    - 状态数据

        - http-get

            > https://ekuiper.org/docs/zh/latest/rules/sources/builtin/http_pull.html

        - database

            > https://ekuiper.org/docs/zh/latest/rules/sources/plugin/sql.html

        - file

            > https://ekuiper.org/docs/zh/latest/rules/sources/builtin/file.html

    </strike>

2. `计算`: function

    > https://ekuiper.org/docs/zh/latest/concepts/rules.html <br/>
    https://ekuiper.org/docs/zh/latest/rules/overview.html <br/>
    https://ekuiper.org/docs/zh/latest/rules/rule_pipeline.html

    - sql: 查询

        > https://ekuiper.org/docs/zh/latest/concepts/sql.html <br/>
        https://ekuiper.org/docs/zh/latest/sqls/overview.html

    - action: 逻辑

        - function: 内置函数

        - extension: 扩展

            > https://ekuiper.org/docs/zh/latest/extension/overview.html

            - `使用外部服务作为函数扩展`

                > https://ekuiper.org/docs/zh/latest/extension/external/external_func.html

3. `输出`: sink

    > https://ekuiper.org/docs/zh/latest/concepts/sinks.html <br/>
    https://ekuiper.org/docs/zh/latest/rules/sinks/overview.html

    - 控制数据

        - mqtt

            > https://ekuiper.org/docs/zh/latest/rules/sinks/builtin/mqtt.html

        <strike>

        - zeromq

            > https://ekuiper.org/docs/zh/latest/rules/sinks/plugin/zmq.html

        </strike>

        - neuron

            > https://ekuiper.org/docs/zh/latest/rules/sinks/builtin/neuron.html

        <strike>

        - edgex

            > https://ekuiper.org/docs/zh/latest/rules/sinks/builtin/edgex.html

        </strike>

    <strike>

    - 状态数据

        - http-post

            > https://ekuiper.org/docs/zh/latest/rules/sinks/builtin/rest.html

        - database

            > https://ekuiper.org/docs/zh/latest/rules/sinks/plugin/sql.html

            - tdengine

                > https://ekuiper.org/docs/zh/latest/rules/sinks/plugin/tdengine.html

        - file

            > https://ekuiper.org/docs/zh/latest/rules/sinks/plugin/file.html

        - log

            > https://ekuiper.org/docs/zh/latest/rules/sinks/builtin/log.html

    </strike>

## api

### http

> https://ekuiper.org/docs/zh/latest/operation/restapi/overview.html

- stream

    > https://ekuiper.org/docs/zh/latest/operation/restapi/streams.html

- rule

    > https://ekuiper.org/docs/zh/latest/operation/restapi/rules.html

- extension

    > https://ekuiper.org/docs/zh/latest/operation/restapi/plugins.html

    - 使用外部服务作为函数扩展

        > https://ekuiper.org/docs/zh/latest/operation/restapi/services.html

#### ui

> warning: kuiper-manager is not open source <br/>
https://ekuiper.org/docs/zh/latest/operation/manager-ui/overview.html

### rpc

> https://ekuiper.org/docs/zh/latest/operation/cli/overview.html

- stream

    > https://ekuiper.org/docs/zh/latest/operation/cli/streams.html

- rule

    > https://ekuiper.org/docs/zh/latest/operation/cli/rules.html

- extension

    > https://ekuiper.org/docs/zh/latest/operation/cli/plugins.html

## dev

> https://ekuiper.org/docs/zh/latest/CONTRIBUTING.html
