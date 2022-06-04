# AIoT

1. things

    things 即万物, 是 device 的数据源. things 包括两种类型数据:

    1. 自然数据(环境数据)

        - 温度、湿度

            - 自动调节空调

        - 光照

            - 改变玻璃颜色

            - 太阳能

        - 红外线

            - 开关灯

        - 风力

            - 通风系统

            - 发电

        - ···

    2. 人为数据(人造物数据)

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

3. edge: ~~俗称`边缘网关`~~

    <div align="center">
        <img src="https://static.emqx.com/_nuxt/img/banner-en-bg.4968787.png" style="width: 98%;" alt="https://static.emqx.com/_nuxt/img/banner-en-bg.4968787.png" />
    </div>

    <strike>

    1. 数据转换

        若上报到 edge 的数据不是 device 上报, 而是 things(如工控机) 直接上报的, 则需要由运行于 edge 上的`数据格式转换软件`将 things 数据格式转换为 mqtt 数据格式, 然后发送到 mqtt-edge。

        同样, 对 things 下发指令, 也需要由运行于 edge 上的数据格式转换软件将 mqtt 数据格式转换为 things 数据格式。

    </strike>

    2. 消息队列: mqtt-edge

    3. 数据处理(规则引擎、规则流水线)

        - 基于 sql 实时处理(提取、转换、聚合、路由)取自 mqtt-edge 的 things 数据

        - 将 mqtt-cloud 下发的指令转发到 device

    4. 数据桥接

        things 数据经 edge 桥接到 mqtt-cloud

4. cloud

    > https://github.com/emqx/edge-stack/blob/master/readme-cn.md <br/>
    https://www.emqx.com/zh/blog/emq-industrial-internet-cloud-edge-integrated-solution#解决方案2-云边协同工业互联网平台

    <div align="center">
        <img src="https://static.emqx.com/_nuxt/img/integrate.1997e7f.png" style="width: 98%;" alt="https://static.emqx.com/_nuxt/img/integrate.1997e7f.png" />
    </div>

    1. 消息队列: mqtt-cloud

    2. 数据处理(规则引擎、规则流水线)

        - 基于 sql 实时处理(提取、转换、聚合、路由)取自 mqtt-cloud 的 things 数据

        - 下发指令到 device (先下发到 mqtt-cloud, mqtt-cloud 转发到 mqtt-edge, mqtt-edge 再转发到 device)

    3. 时序数据库

        将 device 经 edge 上报的 things 数据持久化到数据库

    4. 应用程序

        提取、处理时序数据库中的 things 数据, 向用户提供交互式 UI

## 示例

1. things -> device -> edge(neuron -> emqx-edge -> kuiper) -> cloud(emqx -> tdengine -> grafana)

    > https://www.emqx.com/zh/blog/emqx-tdengine-grafana <br/>
    https://github.com/emqx/edge-stack/blob/master/developer-scripts/readme-cn.md
