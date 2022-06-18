# emqx-edge

> the document of emqx-edge seems no longer maintenance:
>
> ~~https://docs.emqx.io/en/edge/latest/, https://github.com/emqx/emqx-edge-docs/blob/master/zh_CN/~~

note: emqx-edge 的本质就是 emqx, 只是在编译时比 emqx 少编译了一些模块.

warning: emqx-edge 有以下非常不合理的地方

- 编译了 auth-mysql、auth-http; dashboard; retainer、web-hook、rule-engine 等很多不适合 edge 的模块

- 没有编译 prometheus 等非常重要的模块

可见 `emqx-edge 虽然取名为 edge, 但并不适合 edge`. 因此建议不要使用官方 emqx-edge 镜像, 而是重新编译 emqx-edge 并生成镜像; 或者直接使用 emqx 镜像.

## server

### 功能

- `消息桥接`

    > https://www.emqx.io/docs/zh/v4.4/advanced/bridge.html
    >
    > https://www.emqx.io/docs/zh/v4.4/bridge/bridge-mqtt.html

    emqx-edge 作为 client 转发(桥接) message 到其他 mqtt-server(如 mqtt-cloud)

    - `消息缓存`

        emqx-edge 与 emqx 断连时, client(如 device) 发布的 message(称为`离线消息`) 不丢失, 连接恢复后继续转发(桥接)

        - 缓存到磁盘

            `emqx_bridge_mqtt` 模块原生支持桥接数据缓存到磁盘

        <strike>

        - 缓存到数据库

            > https://docs.emqx.com/zh/enterprise/v4.4/rule/offline_msg_to_pgsql.html

        </strike>
