# cloud-ai

cloud-ai 是 "cloud-app 自动指令" 的数据源. cloud-ai 负责以下能力:

1. "cloud-app 自动指令" 的数据源

    cloud-ai 对 device 经 edge 上报的 things 数据进行仿真模拟和预测, 将预测的 device 最佳参数反馈到 cloud-app.

    cloud-app 将 device 最佳参数下发到 device, 并写入 time-series-database.

2. 模型训练

    edge-ai 不具备模型训练的硬件条件, 模型在 cloud-ai 训练后下发到 edge-ai.
