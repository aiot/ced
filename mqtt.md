# mqtt

> https://www.emqx.io/docs/zh/v4.4/development/protocol.html

## connect options

- clean session: 清除会话

    - 1

        开启 clean session, client 断连时, 清除会话

    - 0

        关闭 clean session

- keepalive: 保持连接

    client 周期向 server 发送 pingreq, server 收到后返回 pingresp, 使 client 与 server 之间保持连接

- will msg:

    client 异常离线时(client 断连前未向 server 发送 disconnect message), server 向订阅者发送 will message

- retain msg: 保留消息

    > https://www.emqx.io/docs/zh/v4.4/advanced/retained.html

    client 向 server 发布 message 时, 可以设置 retained message 标志, 一个 topic 只能有一个保留消息.

    保留消息会保留在 server, 订阅者与 server 建立连接时, 如果订阅者订阅的 topic 下有保留消息, 则保留消息会立刻 push 到订阅者

## msg

### topic

- 通配符

    - `things/+`

        通配一个层级, 如 things/x, things/y, ···

    - `things/#`

        通配多个层级, 如 things/x, things/x/y, ···

- metric topic: `$SYS/#`

    > https://www.emqx.io/docs/zh/v4.4/advanced/system-topic.html

### QoS: Quality of Service (服务质量)

> https://www.emqx.com/zh/blog/introduction-to-mqtt-qos

- 0

    sender 只发送一次 msg, 无法确定 receiver 是否收到 msg, 无重发机制

- 1

    sender 发送 msg 后, 等待 receiver 的 ack 回复, 若没有收到 ack 则重发.

    可以保证 receiver 至少收到一次 msg, 但无法保证重复

- 2

    保证 receiver 收到且只收到一次 msg
