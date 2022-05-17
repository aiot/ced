# emqx-edge

> the document of emqx-edge seems no longer maintenance: <br/>
~~https://docs.emqx.io/en/edge/latest/~~ <br/>
~~https://github.com/emqx/emqx-edge-docs/blob/master/zh_CN/~~

## server

### 功能

- `消息桥接`

    > https://www.emqx.io/docs/zh/v4.4/advanced/bridge.html <br/>
    https://www.emqx.io/docs/zh/v4.4/bridge/bridge-mqtt.html

    emqx-edge 作为 client 转发(桥接) message 到其他 mqtt-server(如 mqtt-cloud)

    - `消息缓存`

        emqx-edge 与 emqx 断连时, client(如 device) 发布的 message(称为`离线消息`) 不丢失, 连接恢复后继续转发(桥接)

        - 缓存到磁盘

            `emqx_bridge_mqtt` 模块原生支持桥接数据缓存到磁盘

        <strike>

        - 缓存到数据库

            > https://docs.emqx.com/zh/enterprise/v4.4/rule/offline_msg_to_pgsql.html

        </strike>
