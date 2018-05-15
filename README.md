# Выпускная работа для проекта OTUS ( CI/CD, monitoring, logging для 2-х приложений)

## Предварительные требования

На локальной машине должны быть установлены:
- `terraform`
- `kubectl`
- `helm`

## Развертывание инфраструктуры

Развертывание инфраструктуры происходит с помощью `terraform`. Сама
инфраструктура представляет собой 3 `kubernetes` кластера.
- `gitlab` - в нем располагается все, что касается `CI/CD`
- `ops` - в нем располагается все, что касается мониторинга/логирования
- `dev` - в нем располагаются окружения для наших приложений.

Изначально планировал сделать отдельное окружение `prod` для продакшн среды, но
отказался ввиду стоимости биллинга от `GCE`.

Что было сделано предварительно, до автоматизированного развертывания:

1. Зарегистрирован dns-домен `andywow.xyz` на `GoDaddy`.
2. Управление доменом было делегировано google-серверам (`Cloud DNS`).
3. В `GCE` создан `bucket` для хранения конфигурации `terraform`.
4. В `GCE` заведен отдельный аккаунт `IAM` с правами администратора
k8s-кластеров. Данные аккаунта должны быть сохранены в json-файле. (-x-)

Развертывание инфраструктуры делается из каталога [terraforml](./terraform).

Предварительно необходимо выполнить команды:
```
terraform init -backend-config=backend.conf
```
`backend.conf` - конфигурационный файл с указанием `GCE-bucket`-а.
Пример: [backend.conf.example](./terraform/backend.conf.example).

Далее необходимо создать файл с переменными для развертывания инфраструктуры
`terraform.tfvars`. Пример:
[terraform.tfvars.example](./terraform/terraform.tfvars.example).

Переменная|Описание
-|-
gke_min_version|Версия GKE
project|ID-проекта
region|Регион по-умолчанию для проекта
dns_zone_root_name|Главная DNS-зона для домена
gitlab_cluster_name|Имя кластера для CI/CD
gitlab_node_count|Количество узлов CI/CD кластера
gitlab_node_disk_size|Размер диска CI/CD кластера
gitlab_node_machine_type|Тип машины CI/CD кластера
gitlab_region|Регион CI/CD кластера
gitlab_zone|Зона CI/CD кластера
dev_cluster_name|Имя кластера для DEV
dev_node_count|Количество узлов DEV кластера
dev_node_disk_size|Размер диска DEV кластера
dev_node_machine_type|Тип машины DEV кластера
dev_region|Регион DEV кластера
dev_zone|Зона DEV кластера
ops_cluster_name|Имя кластера для OPS
ops_node_count|Количество узлов OPS кластера
ops_node_disk_size|Размер диска OPS кластера
ops_node_machine_type|Тип машины OPS кластера
ops_region|Регион OPS кластера
ops_zone|Зона OPS кластера

После установки требуемых значений, выполнить команду
```
terraform apply
```

#### Небольшой баг
Приходится коментировать в файле `main.tf` создание DNS-альясов модулем
`dns_aliases`, т.к. до создания k8s-кластера terraform отказывается использовать
адрес его endpoint-а. В результате команду приходится выполнять в 2 этапа.

После выплнения команды произойдет развертывание кластеров. Аутентификационные
данные для подключения к кластерам автоматически пропишутся в локальный конфиг
`kubernetes`. На данные кластера будет выполна установка `tiller`-а.

## Развертывание CI/CD инфраструктуры

Можно выполнить скриптом [setup_cicd.sh](./kubernetes/scripts/setup_cicd.sh).
Предварительно необходимо изменить значения переменных в файле
[values.yaml](./kubernetes/charts/cicd/values.yaml)

В данный момент мой Gitlab хост доступен по адресу:
https://gitlab.cicd.andywow.xyz
Login/pass для тестового пользователя: `otusguest/otusguest`

В группе проектов `Search Engine` находятся три проекта:
- `search_engine_crawler` и `search_engine_ui` - наши исходные приложения.
- `search_engine_infra` - отдельный репозиторий с инфраструктурой для `staging`
и `production` окружений.

Приложения собираются в `Docker`-образы, а затем деплоятся с помощью `helm` в
`kubernetes`.

Делал отдельные развертывания окружений под каждое приложение на стадии `review`,
т.к. допускалось, что приложения пишут разные разработчики.

Для работы `CI/CD pipeline`-а в настройках группы проектов должны быть заданы
следующие переменные:

Переменная|Описание
-|-
XCI_GCE_AUTH_DEV|Base64-закодированные данные для авторизации в DEV GKE (см. (-x-) )
XCI_GCE_AUTH_PROD|Base64-закодированные данные для авторизации в PROD GKE (см. (-x-) )
XCI_GCE_ZONE_DEV|GCE-зона DEV-кластера
XCI_GCE_ZONE_PROD|GCE-зона PROD-кластера
XCI_REGISTRY_PASSWORD|Отдельный пользователь `gitlab` для того, чтобы соседний `k8s`-кластер мог делать `pull` Docker-образов из нашего `registry`
XCI_REGISTRY_USER|Пароль пользователя из предыдущего пункта


#### TODO CI/CD
- попробовать установить `ChartMuseum` и релизить chart-ы в него
- попробовать Docker security тесты, Code security тесты.
- попробовать использовать встроенный в `gitlab` функционал для деплоя в `k8s`
- попробовать разворачивать `gitlab-runner` chart на `dev` кластер и запускать
некоторые `job`-ы в нем по тегам.

## Развертывание OPS инфраструктуры

Можно выполнить скриптом [setup_ops.sh](./kubernetes/scripts/setup_ops.sh).
Предварительно необходимо изменить значения переменных в файлах
[values.yaml](./kubernetes/charts/monitoring/values.yaml) и
[values.yaml](./kubernetes/charts/efk/values.yaml).
В скрипте необходимо поменять параметр `nginx-ingress.controller.service.loadBalancerIP`
на свой статически выделенный `ip-адрес` (в процессе работы `terraform`)

Необходимо поменять значения переменных:
Переменная|Описание
-|-
baseDomain|Базовый домен
grafana.adminPassword|Пароль для первоначального входя в `Grafana`
targets для `prometheus/job_name:'federate'` | Адреса `k8s` кластеров, с которых будут собираться метрики
alertmanager.* | свои данные для отправки алертов

В процессе развертывания происходин установка:
- `prometheus`, `alertmanager`, `grafana` для мониторинга
- `elasticsearch`, `kibana` для логирования

Дашборды в `grafana` устанавливаются автоматически.

#### TODO OPS
- попробовать решение Фланты на базе `fluentd` и `clickhouse` для логирования

## Развертывание DEV инфраструктуры

Можно выполнить скриптом [setup_dev.sh](./kubernetes/scripts/setup_dev.sh).
Предварительно необходимо изменить значения переменных в файле
[values.yaml](./kubernetes/charts/monitoring/values.yaml).
В скрипте необходимо поменять параметр `nginx-ingress.controller.service.loadBalancerIP`
на свой статически выделенный `ip-адрес` (в процессе работы `terraform`)

Будут установлены:
- `fluentd` для передачи логов в `elasticsearch`
- `prometheus`, который будет собирать метрики с DEV-кластера. Из этого
`prometheus` будет собирать метрики `prometheus`, установленный в `OPS`-кластере.




