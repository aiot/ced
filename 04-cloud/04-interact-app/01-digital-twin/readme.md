# digital-twin: 数字孪生

digital-twin 是 cloud-app 的前端. digital-twin 负责以下能力:

1. things、device 可视化

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

2. 指令下发

    > 指令优先级: <br/>
    > 1. digital-twin 手动指令 <br/>
    > 2. cloud-app 自动指令 <br/>
    > 3. edge-app 自动指令

    ---

    > "cloud-app 自动指令" 与 "edge-app 自动指令" 的优缺点 <br/>
    > - "cloud-app 自动指令": 实时性差, 准确性高 <br/>
    > - "edge-app 自动指令": 实时性高, 准确性略差

    ---

    在 digital-twin 上可以选择是否开启 "cloud-app 自动指令", 默认开启.

    1. 自动下发

        考虑到 "edge-app 自动指令" 可能因为 edge-ai 模型更新不及时而导致准确性略差, cloud-app 可以根据 cloud-ai 的预测自动下发指令到 device (指令最终经 edge 下发到 device)

        > note: <br/>
        > 1. 为什么有了 "edge-app 自动指令", 还需要 "cloud-app 自动指令" <br/>
        >     cloud-ai 的预测比 edge-ai 更准确, "cloud-app 自动指令" 主要作为 "edge-app 自动指令" 的辅助工具, 在 cloud-edge 网络良好的情况下, 可以修正 "edge-app 自动指令". <br/>
        >     但通常情况下, cloud-edge 之间的网络质量是不能保证, "cloud-app 自动指令" 不能保证实时性, 所以 "edge-app 自动指令" 起主要作用, "cloud-app 自动指令" 只是 "edge-app 自动指令" 的辅助.

    2. 手动下发

        在 digital-twin 上可以调用 cloud-app 对 device 手动下发指令.

        > note: <br/>
        > 1. device 参数通常情况下由 edge-ai 和 cloud-ai 自动调整, 若 digital-twin 的使用者观察到 device 的参数明显反常, 认为 ai 的预测出现了错误, 可以对 device 手动下发指令. <br/>
        >     edge-app 在向 device 下发指令时, 应优先考虑 cloud-app 下发的指令, 再考虑 edge-app 下发的指令. 若 "cloud-app 指令" 和 "edge-app 指令" 同时存在, 则 "edge-app 指令" 将被忽略.

        ---

        > warning: <br/>
        > 1. 建议不要在 digital-twin 上对 device 手动下发指令, 应优先考虑使用 ai 自动更改 device 参数. <br/>
        >     若发现 device 状态有明显错误, 应考虑修正 ai 模型.
