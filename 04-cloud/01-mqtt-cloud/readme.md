# mqtt-cloud

mqtt-cloud 是 cloud-app 的数据源.

## 功能

> https://docs.emqx.com/zh/enterprise/v4.4/introduction/checklist.html

- 支持证书认证

    - mqtt-cloud 作为 server 时, 支持 client(如 edge-app、mqtt-edge) 使用证书认证

    - mqtt-cloud 作为 client 向其他 mqtt-server 转发(桥接) message 时, 支持使用证书向其他 mqtt-server 发起认证

- 支持 message 缓存

    - mqtt-cloud 作为 client 转发(桥接) message 到其他 mqtt-server 时, 与其他 mqtt-server 断连, message 不丢失, 连接恢复后继续转发(桥接)

- 支持获取 client(如 edge-app、mqtt-edge) 收到 message 的 ACK 应答信息

- 支持 http api

    - 支持通过 api 关闭非法连接

    - 支持 dashboard 管理多 mqtt-server 实例
