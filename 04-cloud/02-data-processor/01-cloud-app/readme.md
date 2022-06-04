# cloud-app

cloud-app 是 cloud-ai 的数据源和 digital-twin 的后端. cloud-app 取代经典 IoT 中的规则引擎, 负责以下能力:

1. 处理来自 mqtt-cloud 的 things 数据

    - 转发 cloud-ai 需要的 things 数据至 cloud-ai, 进行仿真模拟与预测

        - 将 cloud-ai 预测的 device 最佳参数写入 time-series-database

    - 持久化 things 数据到 time-series-database

2. 指令下发

    1. 自动下发

        将 cloud-ai 预测的 device 最佳参数下发到 device

    2. 手动下发

        下发 device 参数到 device

3. 模型下发

    使用 cronjob 将 cloud-ai 训练的模型下发到 edge-ai
