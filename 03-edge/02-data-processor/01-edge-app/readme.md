# edge-app

edge-app 是 edge-ai 的数据源. edge-app 取代经典 IoT 中的规则引擎, 负责以下能力:

1. 处理来自 mqtt-edge 的 things 数据

    - 转发 edge-ai 需要的 things 数据至 edge-ai, 进行预测

    - 压缩并转发 things 数据至 mqtt-cloud. cloud-app 将来自 mqtt-cloud 的 things 数据持久化到 time-series-database

2. 指令下发

    1. 自动下发

        将 edge-ai 预测的 device 最佳参数下发到 device

    2. 手动下发

        转发 "digital-twin 手动指令" 到 device
