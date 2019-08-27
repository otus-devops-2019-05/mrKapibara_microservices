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

<details>
    <summary>03. Сетевое взаимодействие Docker контейнеров. Docker Compose. Тестирование образов
    </summary>
<p>

# Сетевое взаимодействие Docker контейнеров. Docker Compose. Тестирование образов

## Драйвера сети в Docker

- [bridge](https://docs.docker.com/network/bridge/) - мост между несколькими контейнерами. без явного указания, будет использоваться этот драйвер.
- [host](https://docs.docker.com/network/host/) - подключение к сети, машины, на которой запущен контейнер
- [overlay](https://docs.docker.com/network/overlay/) - для соединения docker демонов запущенных на разных машинах
- [macvlan](https://docs.docker.com/network/macvlan/) - назначает каждому контейнеру MAC
- [none](https://docs.docker.com/network/none/) - Отключает локальный контейнер от сети, оставляя только localhost
- [Network plugin](https://docs.docker.com/engine/extend/plugins_services/) - см. документацию


## Docker-compose

Утилита для запуска приложений, разбитых на множество контейнеров

Компоненты приложения описываются в Dockerfile-ах [comment](src/comment/Dockerfile), [post](src/post-py/Dockerfile), [ui](src/ui/Dockerfile) и 
собираются в [docker-compose](src/docker-compose.yml) файле в один сервис, который можно запустить одной командой `docker-compose up -d`

Изменить имя создаваемого контейнера можно через директиву `container_name` d docker-compose файле, во время запуска с ключём -p, --project-name NAME, через [переменные окружения](https://docs.docker.com/compose/reference/envvars/).

## override & файл окружения 

docker-compose во время запуска считывает файлы:
- [docker-compose.yml](src/docker-compose.yml) - основной файл
- [docker-compose.override.yml](src/docker-compose.override.yml) - перопределяет переменные
- [.env](src/.env.example) - файл переменных окружения

</p>
</details>

<details>
    <summary>04. Устройство Gitlab CI. Построение процесса непрерывной интеграции.
    </summary>
<p>

# Устройство Gitlab CI. Построение процесса непрерывной интеграции.

Gitlab CI - инструмент построения пайплайна непрерывной поставки\развертывания. Разделён на 2 части: Сервер управления и Раннеры, на которых проходит сборка и тестирование кода.

Все этапы и задачи описываются в файле [.gitlab-ci.yml](.gitlab-ci.yml), лежащего в корне репозитория.

<details>
    <summary>структура файла:</summary>

    # Объявляем docker-образ
    image: ruby:2.4.2

    # Этапы пайплайна 
    stages:
    - build
    - test
    - review
    - stage
    - production

    # Переменные окружения
    variables:
        DATABASE_URL: 'mongodb://mongo/user_posts'

    # Блок будет выполняться перед запуском каждой задачи
    before_script:
    - cd reddit
    - bundle install

    # Название задачи может быть любым
    # Задачи для этапа build
    build_job:
        stage: build
        script:
            - echo 'Building'

    # Задачи для этапа test
    test_unit_job:
        stage: test
        # Образ, запускаемый во время выполнения задачи
        services:
            - mongo:latest
        script:
            - ruby simpletest.rb

    test_integration_job:
        stage: test
        script:
            - echo 'Testing 2'

    deploy_dev_job:
        stage: review
        script:
            - echo 'Deploy'
        environment:
            name: dev
            url: http://dev.example.com

    # Динамическое окружение
    branch review:
        stage: review
        script: echo "Deploy to $CI_ENVIRONMENT_SLUG"
        environment:
            name: branch/$CI_COMMIT_REF_NAME
            url: http://$CI_ENVIRONMENT_SLUG.example.com
        only:
            - branches
        except:
            - master

    staging:
        stage: stage
        # Можно установить выполнение задачи, по нажатию кнопки
        when: manual
        # Условия для запуска задачи (например тэг 1.1.1)
        only:
            - /^\d+\.\d+\.\d+/
        script:
            - echo 'Deploy'
        environment:
            name: stage
            url: https://beta.example.com

    production:
        stage: production
        when: manual
        only:
            - /^\d+\.\d+\.\d+/
        script:
            - echo 'Deploy'
        environment:
            name: production
            url: https://example.com

</details>

Во время сборки есть возможность использовать [Предопределенные переменные](https://docs.gitlab.com/ee/ci/variables/predefined_variables.html) или [назначить переменные](https://docs.gitlab.com/ee/ci/variables/)

Есть возможность интегрировавть различные [сервисы](https://docs.gitlab.com/ee/user/project/integrations/project_services.html)

[например интеграция slack](https://devops-team-otus.slack.com/messages/CKN8X75CY)

Ссылки:

[quick_start](https://docs.gitlab.com/ee/ci/quick_start/)  
[Небольшой How-to по установке](https://www.howtoforge.com/tutorial/how-to-install-and-configure-gitlab-ce-on-centos-7/)  
[Omnibus](https://docs.gitlab.com/omnibus/docker/README.html#install-gitlab-using-docker-compose)  
[Документация](https://docs.gitlab.com/ee/ci/)  
[Разветрывание контейнера gitlab-ci](https://docs.gitlab.com/ee/ci/docker/using_docker_build.html)

</p>
</details>
