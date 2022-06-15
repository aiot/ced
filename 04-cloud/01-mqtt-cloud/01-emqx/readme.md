# emqx

> https://www.emqx.io/docs/zh/v4.4/, https://docs.emqx.com/zh/enterprise/v4.4/ <br/>
https://github.com/emqx/emqx

## architecture

> https://www.emqx.io/docs/zh/v4.4/design/design.html

## server

> https://www.emqx.io/docs/zh/v4.4/getting-started/command-line.html

- start

    ```bash
    emqx foreground
    ```

### cli: command-line-interface

> https://www.emqx.io/docs/zh/v4.4/advanced/cli.html

- health check

    - instance

        ```bash
        emqx-ctl status
        ```

    - cluster

        ```bash
        emqx-ctl cluster status
        ```

### http api

> https://www.emqx.io/docs/zh/v4.4/advanced/http-api.html

app 调用 emqx api 可以实现以下能力:

- `client 上、下线(connected、disconnected)通知`

    - 实现方式一

        app 通过 emqx api 查询 client 上、下线(connected、disconnected)状态

        - /api/v4/clients

            所有客户端

        - /api/v4/clients/{clientid}

            通过 client-id 指定客户端

    - ~~实现方式二~~

        ~~app 通过订阅 $SYS topic 获取 client 上、下线(connected、disconnected)状态.~~ 强烈建议不要使用这种方式, 局限性太大.

        - ~~$SYS/brokers/${node}/clients/${clientid}/connected~~

        - ~~$SYS/brokers/${node}/clients/${clientid}/disconnected~~

- ~~`消息桥接`~~

    ~~app 通过订阅 emqx-edge 的 topic, 转发(桥接) message 到其他 mqtt-server(如 mqtt-cloud).~~ 建议使用 `emqx_bridge_mqtt` 模块实现.

- ~~`消息持久化`~~

    ~~cloud-app 通过 emqx api 查询并订阅 topic, 然后使用时序数据库的 api 将 message 写入数据库.~~ 建议使用 emqx 消息持久化模块实现.

    > https://www.emqx.com/zh/blog/emqx-rule-engine-series-writing-messages-to-tdengine

#### dashboard

> https://www.emqx.io/docs/zh/v4.4/getting-started/dashboard.html

- 使用单个 dashboard(managed-by-cloud) 管理多个 mqtt-server 实例

    > https://hub.docker.com/r/emqx/edge-manager

### 功能

- `代理订阅`

    > https://www.emqx.io/docs/zh/v4.4/advanced/proxy-subscriptions.html

    订阅者默认订阅的 topic

- ~~`webhook`~~

    > ~~https://www.emqx.io/docs/zh/v4.4/advanced/webhook.html~~

    ~~将 client 上、下线(connected、disconnected)等事件通知到某个 web 服务.~~

    强烈建议不要使用 emqx webhook plugin, 使用 emqx webhook plugin 则 webhook server 必须按照 emqx webhook plugin 所定义的报文格式开发, 可见 emqx webhook plugin 是一个相当鸡肋的功能.

    建议使用 `emqx api` ~~或 `emqx_mod_presence` 模块~~实现 client 上、下线(connected、disconnected)通知等功能.

- `规则引擎`

    - ~~`消息桥接`~~

        > ~~https://www.emqx.io/docs/zh/v4.4/rule/bridge_mqtt.html~~

        ~~使用规则引擎实现消息桥接.~~ 建议使用 `emqx_bridge_mqtt` 模块实现.

    - ~~`消息持久化`~~

        ~~使用规则引擎实现`消息持久化`到数据库.~~ 建议使用消息持久化模块实现.

        - `时序数据库`

            - `tdengine`

                > https://docs.emqx.com/zh/enterprise/v4.4/rule/backend_tdengine.html

        <strike>

        - `关系型数据库`

            - `pgsql`

                > https://docs.emqx.com/zh/enterprise/v4.4/rule/backend_pgsql.html

        </strike>

- ~~`消息桥接`~~

    参见 [mqtt-edge/readme.md](../../../03-edge/01-mqtt-edge/readme.md)

- `消息持久化`

    > https://www.emqx.io/docs/zh/v4.4/backend/backend.html <br/>
    https://docs.emqx.com/zh/enterprise/v4.4/backend/backend_pgsql.html <br/>
    https://www.emqx.com/zh/blog/emqx-plug-in-persistence-series-4-postgresql-data-persistence

## client

### `共享订阅`

> https://www.emqx.io/docs/zh/v4.4/advanced/shared-subscriptions.html

多个订阅者订阅同一 topic 时, 可以使用共享订阅实现同一时间只有一个订阅者收到同一个 message

# emqx operator

> https://github.com/emqx/emqx-operator
