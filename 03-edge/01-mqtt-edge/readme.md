# mqtt-edge

mqtt-edge 是 edge-app 的数据源.

## 功能

- 支持 device 通过证书认证

    - 可以通过 api 关闭非法连接

- 支持获取 device 是否收到 message 的反馈信息

- mqtt-edge 离线, message 不丢失, 上线后 message 继续转发到 mqtt-cloud
