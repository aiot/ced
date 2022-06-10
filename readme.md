# AIoT

1. things

    things 即万物, 是 device 的数据源. things 包括两种类型数据:

    1. 自然数据(环境数据)

        - 电

            - 风力

                - 通风系统

                - 发电

        - 力

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

    2. 人为数据(人造物数据)

        - ~~工控机~~

        - ···

2. device

    device 即智能设备, 是 mqtt-edge 的数据源. device 负责以下能力:

    1. 数据采集(data-acquisition): 采集 things 数据

        - `传感器`

        - `摄像头`

        - ···

    2. 数据上报(data-reporting): 以 mqtt 格式上报 things 数据至 edge

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

3. edge

    ~~edge 在经典 IoT 中称为边缘网关~~. edge 负责以下能力:

    <!-- <div align="center">
        <img src="https://static.emqx.com/_nuxt/img/banner-en-bg.4968787.png" style="width: 98%;" alt="https://static.emqx.com/_nuxt/img/banner-en-bg.4968787.png" />
    </div> -->

    <strike>

    1. 数据转换: 通常应用于工业互联网

        若上报到 edge 的数据不是 device 上报, 而是 things(如工控机) 直接上报的, 则需要由运行于 edge 上的`数据格式转换软件`将 things 数据格式转换为 mqtt 数据格式, 然后发送到 mqtt-edge.

        同样, 对 things 下发指令, 也需要由运行于 edge 上的数据格式转换软件将 mqtt 数据格式转换为 things 数据格式.

    </strike>

    2. 消息队列: mqtt-edge

        mqtt-edge 是 edge-app 的数据源

        功能:

        - 必要: 支持`证书认证`

            - mqtt-edge 作为 server 时, 支持 client(如 device) 使用证书认证

            - mqtt-edge 作为 client 向其他 mqtt-server(如 mqtt-cloud) 转发(桥接) message 时, 支持使用证书向其他 mqtt-server 发起认证

        - 可选: 支持`消息桥接`

            mqtt-edge 作为 client 转发(桥接) message 到其他 mqtt-server(如 mqtt-cloud)

            > 消息桥接是非必要功能. <br/>
            出于安全考虑, 某些 things 数据(如家庭摄像头)必须限制在 edge 侧处理, 因此不一定(实际上多数情况是一定不)所有 device 采集的 things 数据都需要转发(桥接)到 mqtt-cloud. <br/>
            出于网络原因, 转发(桥接)大量 things 数据到 mqtt-cloud 是不具有现实可行性的. <br/>
            确需转发到 mqtt-cloud 的少量原始 things 数据可以通过 edge-app 完成.

            - 支持`消息缓存`

                mqtt-edge 与 mqtt-cloud 断连时, client(如 device) 发布的 message(称为`离线消息`) 不丢失, 连接恢复后继续转发(桥接)

                - 缓存到磁盘

                    建议缓存到磁盘

                <strike>

                - 缓存到数据库(如 sqlite)

                </strike>

        - 必要: 支持 http api

            - 支持通过 api 关闭非法连接

    3. 数据处理

        1. edge-app

            edge-app 是 edge-ai 的数据源.

            ~~在经典 IoT 中称为规则引擎或规则流水线(也称为低代码), 基于 sql 实时处理(提取、转换、聚合、路由)来自 mqtt-edge 的 things 数据.~~

        2. edge-ai

            edge-ai 是 "edge-app 自动指令" 的数据源

4. cloud

    1. 消息队列: mqtt-cloud

        mqtt-cloud 是 cloud-app 的数据源

    2. 数据处理

        1. cloud-app

            cloud-app 是 cloud-ai 的数据源和 digital-twin 的后端

        2. cloud-ai

            cloud-ai 是 "cloud-app 自动指令" 的数据源

    3. 时序数据库

        将 device 经 edge 上报的 things 数据持久化到数据库

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
