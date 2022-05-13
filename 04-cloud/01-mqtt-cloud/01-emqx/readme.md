# emqx

> https://www.emqx.io/docs/zh/v4.4/, https://docs.emqx.com/zh/enterprise/v4.4/ <br/>
https://github.com/emqx/emqx

## architecture

> https://www.emqx.io/docs/zh/v4.4/design/design.html

## server

> https://www.emqx.io/docs/zh/v4.4/getting-started/command-line.html

- start

    ```bash
    emqx foreground
    ```

### cli: command-line-interface

> https://www.emqx.io/docs/zh/v4.4/advanced/cli.html

- health check

    - instance

        ```bash
        emqx-ctl status
        ```

    - cluster

        ```bash
        emqx-ctl cluster status
        ```

### http api

> https://www.emqx.io/docs/zh/v4.4/advanced/http-api.html

#### dashboard

> https://www.emqx.io/docs/zh/v4.4/getting-started/dashboard.html

### 功能

- `代理订阅`

    > https://www.emqx.io/docs/zh/v4.4/advanced/proxy-subscriptions.html

    指定订阅者默认订阅的 topic

- `webhook`

    > https://www.emqx.io/docs/zh/v4.4/advanced/webhook.html

    将 client 上、下线事件等通知到某个 web 服务

## client

### `共享订阅`

> https://www.emqx.io/docs/zh/v4.4/advanced/shared-subscriptions.html

多个订阅者订阅同一 topic 时, 可以使用共享订阅实现同一时间只有一个订阅者收到同一个 message

# emqx operator

> https://github.com/emqx/emqx-operator
