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

    device 即智能设备, 包括硬件(`通信工程`)和软件(`软件工程`)两部分:

    - 硬件(通信工程)

        device 与 edge 之间的通信可以有两种方式:

        1. device 与 edge 分离, 通过`无线通信`将 things 数据上报到 edge

            - LoRA

            - NB-IoT

            - 3/4/5G

            - wifi

        2. device 集成在 edge 上, 通过`有线通信`将 things 数据上报到 edge

            - LAN(网线)

    - 软件(软件工程)

        device 是 mqtt-edge 的数据源, 负责以下能力:

        1. `数据采集`(data-acquisition): 采集 things 数据

            - `传感器`

                温度、湿度等是 `json 数据`

            - `摄像头`

                图片、视频等是`二进制数据`

            - ···

        2. `数据上报`(data-reporting): 以 mqtt 格式上报 things 数据至 edge

            功能:

            - device 离线, message 不丢失, 上线后 message 自动发布到 mqtt-edge

3. `edge`

    edge ~~在`经典IoT`中称为边缘网关,~~ 包括硬件和软件两部分:

    - 硬件(通信工程)

        - 基于 `Raspberry Pi` 构建 edge 硬件

    - 软件(软件工程)

        edge 负责以下能力:

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

                > 消息桥接是非必要功能:
                >
                > 1. 出于实时性考虑, 一些 things 数据必须在 edge 侧就近处理;
                >
                > 2. 出于安全考虑, 一些敏感 things 数据(如家庭摄像头)必须限制在 edge 侧处理, 因此不一定(实际上多数情况是一定不)所有 device 采集的 things 数据都需要转发(桥接)到 mqtt-cloud;
                >
                > 3. 出于网络原因, 转发(桥接)大量 things 数据到 mqtt-cloud 在速度和成本上都是不具有现实可行性的;
                >
                > 4. 应当确保 mqtt-edge 的唯一操作入口是 edge-app, 确需转发到 mqtt-cloud 的少量原始 things 数据可以通过 edge-app 完成.

                - 支持`消息缓存`

                    mqtt-edge 与 mqtt-cloud 断连时, client(如 device) 发布的 message(称为`离线消息`) 不丢失, 连接恢复后继续转发(桥接)

                    - 缓存到磁盘

                        建议缓存到磁盘

                    - ~~缓存到数据库(如 sqlite)~~

                </strike>

            - 必要: 支持 http api

                - 支持通过 api 关闭非法连接

                - 支持一个 dashboard(managed-by-cloud) 管理多个 mqtt-server 实例

        3. 数据处理

            > 知识铺垫
            >
            > - `流处理`
            >
            >     > https://ekuiper.org/docs/zh/latest/concepts/streaming/overview.html
            >
            >     流处理基于事件机制, 每个数据流相当于一个事件, 每个事件触发一次计算. 数据流具有以下属性:
            >
            >     - 时间戳
            >
            >         > https://ekuiper.org/docs/zh/latest/concepts/streaming/time.html
            >
            >         - 事件时间: 事件发生时间
            >
            >         - 处理时间: kuiper 观察到事件的时间
            >
            >     - 窗口
            >
            >         > https://ekuiper.org/docs/zh/latest/concepts/streaming/windowing.html
            >         >
            >         > https://ekuiper.org/docs/zh/latest/sqls/windows.html
            >
            >         - 时间窗口: 按时间段分割的窗口
            >
            >             - 滚动窗口: 将数据流分割成不同的时间段
            >
            >             - 跳跃窗口
            >
            >             - 滑动窗口
            >
            >             - 会话窗口
            >
            >         - 计数窗口: 按元素计数分割的窗口
            >
            > - 批处理
            >
            >     与流处理相对应的是批处理

            1. `edge-app`

                > edge-app 是必需且不能少的. 由于云边网络不稳定, 在 edge 与 cloud 网络断开时, 必须存在 edge-app 对 device 采集的 things 数据进行实时处理.

                edge-app 是 mqtt-edge 的唯一操作入口, 是 edge-ai 的数据源. edge-app ~~取代经典 IoT 中的`规则引擎`(也称`规则流水线`)(一种基于 sql 实时处理(提取、转换、聚合、路由)查询自 mqtt-edge 的 things 数据的`低代码`工具),~~ 负责以下能力:

                1. 处理查询自 mqtt-edge 的 things 数据

                    - 转发 edge-ai 需要的 things 数据至 edge-ai, 进行预测

                    - 压缩并转发非敏感 things 数据至 mqtt-cloud. cloud-app 将查询自 mqtt-cloud 的非敏感 things 数据持久化到时序数据库

                2. 指令下发

                    1. 自动下发

                        将 edge-ai 预测的 device 最佳参数下发到 device (下发到 mqtt-edge, device 订阅 mqtt-edge 相关 topic)

                    2. 转发 "digital-twin 手动指令"

                        转发 "digital-twin 手动指令" 到 device (下发到 mqtt-edge, device 订阅 mqtt-edge 相关 topic)

            2. `edge-ai`

                edge-ai `预训练模型`相当于负责特定逻辑的 edge-app 智能函数. edge-ai 负责以下能力:

                1. "edge-app 自动指令" 的数据源

                    edge-app 将 device 上报的 things 数据传给 edge-ai, edge-ai 对 device 状态进行预测, 将预测的 device 最佳参数返回 edge-app. edge-app 将 device 最佳参数下发到 device (下发到 mqtt-edge, device 订阅 mqtt-edge 相关 topic).

                qa:

                1. edge-ai 可以直接操作 mqtt-edge 对 device 下发指令吗?

                    不可以.

                    首先应当确保 mqtt-edge 的唯一操作入口是 edge-app; 其次所有的指令都应当通过 edge-app 下发, 因为要判断指令优先级.

                reference:

                - `在 kuiper 中以函数形式调用 tensor-flow lite 预训练模型`

                    - https://ekuiper.org/docs/zh/latest/tutorials/ai/tensorflow_lite_tutorial.html

4. `cloud`

    1. `mqtt-cloud`: 消息队列

        mqtt-cloud 是 cloud-app 的数据源

        功能:

        > https://docs.emqx.com/zh/enterprise/v4.4/introduction/checklist.html

        - 必要: 支持证书认证

            - mqtt-cloud 作为 server 时, 支持 client(如 edge-app、mqtt-edge) 使用证书认证

            - mqtt-cloud 作为 client 向其他 mqtt-server 转发(桥接) message 时, 支持使用证书向其他 mqtt-server 发起认证

        <strike>

        - 可选: 支持 message 持久化

            支持 message 持久化到数据库, 供 cloud-app 查询

            > mqtt-cloud 持久化 message 到数据库是非必要功能:
            >
            > 强烈建议不要让 mqtt-cloud 与数据库交互, 与数据库交互的一切动作都应当由 cloud-app 完成, 确保对数据库而言只有一个操作入口.

            - 时序数据库

                - tdengine

            - ~~关系型数据库~~

                - ~~pgsql~~

        </strike>

        - 必要: 支持 http api

            - 支持通过 api 关闭非法连接

            - 支持一个 dashboard(managed-by-cloud) 管理多个 mqtt-server 实例

    2. 数据处理

        1. `cloud-app`

            cloud-app 是 mqtt-cloud 和时序数据库的唯一操作入口, 是 cloud-ai 的数据源和 digital-twin 的后端. cloud-app ~~取代经典 IoT 中的规则引擎,~~ 负责以下能力:

            1. 操作 mqtt-cloud 和时序数据库

                 - 持久化查询自 mqtt-cloud 的非敏感 things 数据至时序数据库

            2. 与 cloud-ai 交互

                - 转发 cloud-ai 需要的 things 数据至 cloud-ai, 进行仿真模拟与预测

                    - 将 cloud-ai 预测的 device 最佳参数写入时序数据库

                - 模型下发

                    使用 cronjob 将 cloud-ai 训练的模型下发到 edge-ai

            3. digital-twin 的后端

                1. 提取、处理时序数据库中的 things(device 采集的 things 数据)、device(cloud-ai 预测的 device 最佳参数) 数据, 返回给  digital-twin

                2. 指令下发

                    1. 自动下发

                        将 cloud-ai 预测的 device 最佳参数下发到 device (先下发到 mqtt-cloud, mqtt-cloud 再转发到 mqtt-edge, device 订阅 mqtt-edge 相关 topic)

                    2. 手动下发

                        下发 device 参数到 device (先下发到 mqtt-cloud, mqtt-cloud 再转发到 mqtt-edge, device 订阅 mqtt-edge 相关 topic)

                    qa:

                    1. cloud-app 可以直接操作 mqtt-edge 对 device 下发指令吗?

                        不可以.

                        首先应当确保 mqtt-edge 的唯一操作入口是 edge-app; 其次所有的指令都应当通过 edge-app 下发, 因为要判断指令优先级; 再次, 由于网络原因, cloud-app 直接操作 mqtt-edge 不具备现实可行性.

        2. `cloud-ai`

            cloud-ai 是 "cloud-app 自动指令" 的数据源. cloud-ai 负责以下能力:

            1. "cloud-app 自动指令" 的数据源

                cloud-ai 对 device 经 edge 上报的 things 数据进行仿真模拟和预测, 将预测的 device 最佳参数反馈到 cloud-app. cloud-app 将 device 最佳参数下发到 device (先下发到 mqtt-cloud, mqtt-cloud 再转发到 mqtt-edge, device 订阅 mqtt-edge 相关 topic), 并写入时序数据库.

            2. `模型训练`

                edge-ai 不具备模型训练的硬件条件, 模型在 cloud-ai 训练后下发到 edge-ai.

            qa:

            1. cloud-ai 可以直接操作 mqtt-edge 对 device 下发指令吗?

                不可以.

                首先应当确保 mqtt-edge 的唯一操作入口是 edge-app; 其次所有的指令都应当通过 edge-app 下发, 因为要判断指令优先级.

    3. `时序数据库`(time-series-database)

        时序数据库是 digital-twin 的数据源

    4. `交互应用`(interact-app)

        1. `digital-twin`: `数字孪生`

            digital-twin 是 cloud-app 的前端. digital-twin 负责以下能力:

            1. `things、device 可视化`

                - 3D 可视化

                    - device 状态

                        - 在/离线状态

                            - 查询

                            - 管理

                                可以强制下线 device

                        - 运行状态

                    - edge 状态

                        - 在/离线状态

                            - 查询

                            - 管理

                                可以强制下线 edge

                - 统计图

            2. `指令下发`

                > `指令优先级`:
                >
                > 1. digital-twin 手动指令
                >
                > 2. cloud-app 自动指令
                >
                > 3. edge-app 自动指令

                > "cloud-app 自动指令" 与 "edge-app 自动指令" 的优缺点:
                >
                > - "cloud-app 自动指令": 实时性差, 准确性高
                >
                > - "edge-app 自动指令": 实时性高, 准确性略差

                在 digital-twin 上可以选择是否开启 "cloud-app 自动指令", 默认开启.

                1. `自动下发`

                    考虑到 "edge-app 自动指令" 可能因为 edge-ai 模型更新不及时而导致准确性略差, cloud-app 可以根据 cloud-ai 的预测自动下发指令到 device (先下发到 mqtt-cloud, mqtt-cloud 再转发到 mqtt-edge, device 订阅 mqtt-edge 相关 topic)

                    > note:
                    >
                    > 1. 为什么有了 "edge-app 自动指令", 还需要 "cloud-app 自动指令"
                    >
                    >     cloud-ai 的预测比 edge-ai 更准确, "cloud-app 自动指令" 主要作为 "edge-app 自动指令" 的辅助工具, 在 cloud-edge 网络良好的情况下, 可以修正 "edge-app 自动指令".
                    >
                    >     但通常情况下, cloud-edge 之间的网络质量是不能保证, "cloud-app 自动指令" 不能保证实时性, 所以 "edge-app 自动指令" 起主要作用, "cloud-app 自动指令" 只是 "edge-app 自动指令" 的辅助.

                2. `手动下发`

                    在 digital-twin 上可以调用 cloud-app 对 device 手动下发指令.

                    > note:
                    >
                    > 1. device 参数通常情况下由 edge-ai 和 cloud-ai 自动调整, 若 digital-twin 的使用者观察到 device 的参数明显反常, 认为 ai 的预测出现了错误, 可以对 device 手动下发指令.
                    >
                    >     edge-app 在向 device 下发指令时, 应优先考虑 cloud-app 下发的指令, 再考虑 edge-app 下发的指令. 若 "cloud-app 指令" 和 "edge-app 指令" 同时存在, 则 "edge-app 指令" 将被忽略.

                    > warning:
                    >
                    > 1. 建议不要在 digital-twin 上对 device 手动下发指令, 应优先考虑使用 ai 自动更改 device 参数.
                    >
                    >     若发现 device 状态有明显错误, 应考虑修正 ai 模型.

        2. `mobile-app`

            mobile-app 是 digital-twin 在移动端的简化版. mobile-app 负责以下能力:

            1. things、device 可视化

                考虑到移动端的硬件条件, mobile-app 将只提供基础可视化, 不提供 "3D 可视化" 能力

            2. 指令下发

## emqx 案例

<div align="center">
    <img src="https://static.emqx.com/_nuxt/img/integrate.1997e7f.png" style="width: 98%;" alt="https://static.emqx.com/_nuxt/img/integrate.1997e7f.png" />
</div>

- https://github.com/emqx/edge-stack/blob/master/readme-cn.md

- https://www.emqx.com/zh/blog/emq-industrial-internet-cloud-edge-integrated-solution#解决方案2-云边协同工业互联网平台

- things -> device -> edge(neuron -> emqx-edge -> kuiper) -> cloud(emqx -> tdengine -> grafana)

    - https://www.emqx.com/zh/blog/emqx-tdengine-grafana

    - https://github.com/emqx/edge-stack/blob/master/developer-scripts/readme-cn.md
