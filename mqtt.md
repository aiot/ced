# mqtt

> https://www.emqx.io/docs/zh/v4.4/development/protocol.html

## connect options

- clean session

- keepalive

- will msg

- retain msg

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

# mqtt-sn
