# `AIoT`

1. `things`

    things 即万物, 是 device 的数据源. things 包括两种类型数据:

    1. `自然数据`(环境数据)

        - 电

        - 力

            - 风力

                - 通风系统

                - 发电

        - 热

            - 温度、湿度

                - 自动调节空调、加湿器

        - 光

            - 光照

                - 改变玻璃颜色

                - 太阳能

            - 红外线

                - 开关灯

        - 声

        - ···

    2. `人造物数据`(人为数据)

        - ~~`工控机`~~

        - ···

2. `device`

    device 即智能设备, 是 mqtt-edge 的数据源. device 负责以下能力:

    1. `数据采集`(data-acquisition): 采集 things 数据

        - `传感器`

        - `摄像头`

        - ···

    2. `数据上报`(data-reporting): 以 mqtt 格式上报 things 数据至 edge

        功能:

        - device 离线, message 不丢失, 上线后 message 自动发布到 mqtt-edge

        通信方式:

        - 无线

            - LoRA

            - NB-IoT

            - 2/3/4/5G

            - wifi

        - 有线

            - LAN(网线)

3. `edge`

    ~~edge 在经典 IoT 中称为边缘网关~~. edge 负责以下能力:

    <!-- <div align="center">
        <img src="https://static.emqx.com/_nuxt/img/banner-en-bg.4968787.png" style="width: 98%;" alt="https://static.emqx.com/_nuxt/img/banner-en-bg.4968787.png" />
    </div> -->

    <strike>

    1. 数据转换: 通常应用于`工业互联网`

        若上报到 edge 的数据不是 device 上报, 而是 things(如工控机) 直接上报的, 则需要由运行于 edge 上的`数据格式转换软件`将 things 数据格式转换为 mqtt 数据格式, 然后发送到 mqtt-edge.

        同样, 对 things 下发指令, 也需要由运行于 edge 上的数据格式转换软件将 mqtt 数据格式转换为 things 数据格式.

    </strike>

    2. `mqtt-edge`: 消息队列

        mqtt-edge 是 edge-app 的数据源

        功能:

        - 必要: 支持`证书认证`

            - mqtt-edge 作为 server 时, 支持 client(如 device) 使用证书认证

            - mqtt-edge 作为 client 向其他 mqtt-server(如 mqtt-cloud) 转发(桥接) message 时, 支持使用证书向其他 mqtt-server 发起认证

        <strike>

        - 可选: 支持`消息桥接`

            mqtt-edge 作为 client 转发(桥接) message 到其他 mqtt-server(如 mqtt-cloud)

            > 消息桥接是非必要功能. <br/>
            出于安全考虑, 一些敏感 things 数据(如家庭摄像头)必须限制在 edge 侧处理, 因此不一定(实际上多数情况是一定不)所有 device 采集的 things 数据都需要转发(桥接)到 mqtt-cloud. <br/>
            出于网络原因, 转发(桥接)大量 things 数据到 mqtt-cloud 是不具有现实可行性的. <br/>
            确需转发到 mqtt-cloud 的少量原始 things 数据可以通过 edge-app 完成.

            - 支持`消息缓存`

                mqtt-edge 与 mqtt-cloud 断连时, client(如 device) 发布的 message(称为`离线消息`) 不丢失, 连接恢复后继续转发(桥接)

                - 缓存到磁盘

                    建议缓存到磁盘

                - ~~缓存到数据库(如 sqlite)~~

            </strike>

        - 必要: 支持 http api

            - 支持通过 api 关闭非法连接

            - 支持一个 dashboard 管理多个 mqtt-server 实例

    3. 数据处理

        1. `edge-app`

            edge-app 是 edge-ai 的数据源. edge-app ~~取代`经典IoT`中的`规则引擎`(也称为`规则流水线`)(一种基于 sql 实时处理(提取、转换、聚合、路由)查询自 mqtt-edge 的 things 数据的`低代码`工具),~~ 负责以下能力:

            1. 处理查询自 mqtt-edge 的 things 数据

                - 转发 edge-ai 需要的 things 数据至 edge-ai, 进行预测

                - 压缩并转发非敏感 things 数据至 mqtt-cloud. cloud-app 将查询自 mqtt-cloud 的非敏感 things 数据持久化到时序数据库

            2. 指令下发

                1. 自动下发

                    将 edge-ai 预测的 device 最佳参数下发到 device (下发到 mqtt-edge, device 订阅 mqtt-edge 相关 topic)

                2. 手动下发

                    转发 "digital-twin 手动指令" 到 device

        2. `edge-ai`

            edge-ai 是 "edge-app 自动指令" 的数据源. edge-ai 负责以下能力:

            1. "edge-app 自动指令" 的数据源

                edge-ai 根据 device 上报的 things 数据, 对 device 状态进行预测, 将预测的 device 最佳参数反馈到 edge-app.

                edge-app 将 device 最佳参数下发到 device.

4. `cloud`

    1. `mqtt-cloud`: 消息队列

        mqtt-cloud 是 cloud-app 的数据源

        功能:

        > https://docs.emqx.com/zh/enterprise/v4.4/introduction/checklist.html

        - 支持证书认证

            - mqtt-cloud 作为 server 时, 支持 client(如 edge-app、mqtt-edge) 使用证书认证

            - mqtt-cloud 作为 client 向其他 mqtt-server 转发(桥接) message 时, 支持使用证书向其他 mqtt-server 发起认证

        - 支持 message 持久化

            支持 message 持久化到数据库, 供 cloud-app 查询

            - 时序数据库

                - tdengine

            <strike>

            - 关系型数据库

                - pgsql

            </strike>

        - 支持 http api

            - 支持通过 api 关闭非法连接

            - 支持一个 dashboard 管理多个 mqtt-server 实例

    2. 数据处理

        1. `cloud-app`

            cloud-app 是 cloud-ai 的数据源和 digital-twin 的后端. cloud-app ~~取代经典 IoT 中的规则引擎,~~ 负责以下能力:

            1. 处理查询自 mqtt-cloud 的非敏感 things 数据

                - 转发 cloud-ai 需要的 things 数据至 cloud-ai, 进行仿真模拟与预测

                    - 将 cloud-ai 预测的 device 最佳参数写入时序数据库

                - 持久化非敏感 things 数据至时序数据库

            2. 指令下发

                1. 自动下发

                    将 cloud-ai 预测的 device 最佳参数下发到 device (先下发到 mqtt-cloud, mqtt-cloud 再转发到 mqtt-edge, device 订阅 mqtt-edge 相关 topic)

                2. 手动下发

                    下发 device 参数到 device

            3. 模型下发

                使用 cronjob 将 cloud-ai 训练的模型下发到 edge-ai

        2. `cloud-ai`

            cloud-ai 是 "cloud-app 自动指令" 的数据源. cloud-ai 负责以下能力:

            1. "cloud-app 自动指令" 的数据源

                cloud-ai 对 device 经 edge 上报的 things 数据进行仿真模拟和预测, 将预测的 device 最佳参数反馈到 cloud-app.

                cloud-app 将 device 最佳参数下发到 device, 并写入时序数据库.

            2. 模型训练

                edge-ai 不具备模型训练的硬件条件, 模型在 cloud-ai 训练后下发到 edge-ai.

    3. `时序数据库`: time-series-database

        时序数据库是 digital-twin 的数据源

    4. 应用程序

        提取、处理时序数据库中的 things 数据, 向用户提供交互式 UI

## 示例

> https://github.com/emqx/edge-stack/blob/master/readme-cn.md <br/>
https://www.emqx.com/zh/blog/emq-industrial-internet-cloud-edge-integrated-solution#解决方案2-云边协同工业互联网平台

<div align="center">
    <img src="https://static.emqx.com/_nuxt/img/integrate.1997e7f.png" style="width: 98%;" alt="https://static.emqx.com/_nuxt/img/integrate.1997e7f.png" />
</div>

1. things -> device -> edge(neuron -> emqx-edge -> kuiper) -> cloud(emqx -> tdengine -> grafana)

    > https://www.emqx.com/zh/blog/emqx-tdengine-grafana <br/>
    https://github.com/emqx/edge-stack/blob/master/developer-scripts/readme-cn.md
