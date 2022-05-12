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

    client 向 server 发布 message 时, 可以设置 retained message 标志. retained message 会保留在 server, 供订阅者接收

## msg

### topic

- 通配符

    - `things/+`

        通配一个层级, 如 things/x, things/y, ···

    - `things/#`

        通配多个层级, 如 things/x, things/x/y, ···

- 系统消息

    `$SYS/#`

### QoS: Quality of Service (服务质量)

> https://www.emqx.com/zh/blog/introduction-to-mqtt-qos

- 0

    sender 只发送一次 msg, 无法确定 receiver 是否收到 msg, 无重发机制

- 1

    sender 发送 msg 后, 等待 receiver 的 ack, 若没有收到 ack 则重发.

    可以保证 receiver 至少收到一次 msg, 但无法保证重复

- 2

    保证 receiver 收到且只收到一次 msg
