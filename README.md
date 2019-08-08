# mrKapibara_microservices

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
