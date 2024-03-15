# Docker

[Docker RomNero](https://www.youtube.com/playlist?list=PLqVeG_R3qMSwjnkMUns_Yc4zF_PtUZmB-)  
[Docker Swarm: деплой и управление окружением на практике (полный курс)](https://www.youtube.com/watch?v=GgkreJfdTL8)  
[DevOps by Rebrain: Быстрый старт с Docker Swarm](https://www.youtube.com/watch?v=y1G4F7bzofk)

Подключение по ssh:  
`ssh USER@SERVER -i PATH_TO_PUB_KEY`

Войти в контейнер на swarm:

```shell
docker exec -ti gis_api-fields.1.$(docker service ps -f 'name=gis_api-fields.1' gis_api-fields -q --no-trunc | head -n1) /bin/bash
docker exec -ti gis_api-fields.1.g0l63rqgxb2ytez5sk6dwi5jq /bin/bash
```

## Команды

| Команда                                   | Описание                              |
|-------------------------------------------|---------------------------------------|
| &nbsp;                                    | &nbsp;                                |
| `docker container ls`                     | список контейнеров                    |
| `docker stack ls`                         | список стеков                         |
| `docker service ls`                       | список сервисов (на всех стеках)      |
| `docker stack services НАЗВАНИЕ_СТЕКА`    | список сервисов на конкретном стеке   |
| &nbsp;                                    | &nbsp;                                |
| `docker inspect НАЗВАНИЕ_СТЕКА`           | данные, с которыми был создан стек    |
| `docker service inspect НАЗВАНИЕ_СЕРВИСА` | данные, с которыми был создан сервис  |
| &nbsp;                                    | &nbsp;                                |
| `docker service ps НАЗВАНИЕ_СЕРВИСА`      | на какой ноде кластера запущен сервис |
| &nbsp;                                    | &nbsp;                                |
| `docker service scale ID_FROM_LS=0`       | масштабировать контейнер              |

## Программы

#### MSSQL

Если захочешь поднять mssql локально, то проще поднять в докере:

1. `docker pull mcr.microsoft.com/mssql/server:2019-latest`
2. Create directory for mssql data. Example: `/Users/temp/Desktop/sqlData`
3. `docker run --name DockerSql -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD={rootPassword}' -v /Users/temp/Desktop/sqlData:/var/opt/mssql/data -p 1433:1433 -d mcr.microsoft.com/mssql/server:2019-latest`
4. Check connection via something like Rider/Datagrip/etc
5. User: sa  











