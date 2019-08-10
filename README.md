# mrKapibara_microservices [![Build Status](https://travis-ci.com/otus-devops-2019-05/mrKapibara_microservices.svg?branch=master)](https://travis-ci.com/otus-devops-2019-05/mrKapibara_microservices)

<details><summary>01. Технология контейнеризации.Введение в Docker</summary>
<p>

# Технология контейнеризации.Введение в Docker

## Docker

Инструмент для создания образов и развертывания из них контейнеров. Используется для поставки ПО. 
Для изоляции процессов использует [namespaces](https://habr.com/ru/post/458462/).
Для ограничения ограничения ресурсов [cgroups](https://habr.com/ru/company/selectel/blog/303190/)

## [Dockerfile](docker-monolith/Dockerfile)
Файл содержащий инструкции для создания образа  
[Документация](https://docs.docker.com/engine/reference/builder/)

## Docker-machine

Инструмент для установки Docker engine на удалённом сервере и управления им.  
[Документация](https://docs.docker.com/machine/overview/)

В рамках выполнения задания было сделано:
- описано создание docker образа [пакером](docker-monolith/infra/packer/docker.json)
- описаны окружения для развертывания тераформом [prod](docker-monolith/infra/terraform/prod/), [stage](docker-monolith/infra/terraform/stage/)
- написаны роли для [установки докера](docker-monolith/infra/ansible/roles/docker), [запуска образа на инстансе с докером](docker-monolith/infra/ansible/roles/docker-monolith-app)

</p>
</details>

<details><summary>02. Docker-образы. Микросервисы</summary>
<p>

# Docker-образы. Микросервисы

## Микросервисы.

Монолит разбит на 4 микросервиса. Для каждого написан свой Dockerfile: [comment](src/comment/Dockerfile), [post](src/post-py/Dockerfile), [ui](src/ui/Dockerfile) и базу данных.
Взаимодействуют микросервисы будут внутри своей сети, создадим её:

    docker create network reddit

Тепперь при запуске контеейнера будем указывать ключ `--network=reddit`. Внутри Dockerfile указаны переменные по которым они опознают соседей:

    ...
    ENV COMMENT_DATABASE_HOST comment_db
    ...

Для запуска контейнера с указанием сетегого имени используем ключ `--network-alias`. Запуск контейнера:

    docker run -d --network=reddit --network-alias=post_db_new --network-alias=comment_db -v reddit_db:/data/db mongo:latest

Так же можно указать переменные при запуске контейнера используя ключ `-e COMMENT_DATABASE_HOST=comment_db_new_alias`

После небольшой оптимизации Dockerfile'ов, рамер их стал меньше:

    $ docker images
    REPOSITORY           TAG                 IMAGE ID            CREATED              SIZE
    mrkapibara/ui        1.0-alpine          269287dc73b9        26 seconds ago       72.5MB
    mrkapibara/ui        1.0-ubuntu16        e184f12ca2b7        About a minute ago   229MB
    mrkapibara/post-py   1.0-alpine          fe2741ce7dc8        2 minutes ago        106MB
    mrkapibara/comment   1.0-alpine          b2ac3478232a        3 minutes ago        70.4MB
    mrkapibara/comment   1.0-ruby            ae19df2e03e6        4 minutes ago        775MB

</p>
</details>
