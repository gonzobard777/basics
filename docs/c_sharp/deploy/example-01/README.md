# online-backend мое первое

.gitlab-ci.yml

```yaml
stages:
  - no_pipeline_run
  - publish_and_push
  - deploy

.docker_login: &docker_login
  before_script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY

.only_tags: &onlyTags
  only:
    - tags

no pipeline run:
  stage: no_pipeline_run
  except:
    - tags
  script:
    - |
      echo 'Пайплайн не будет запущен. Он запускается только то тэгу версии'
      echo 'Для запуска пайплайна используйте следующие шаги'
      echo 'git commit'
      echo 'git tag {semver tag}'
      echo 'git push'
      echo 'git push --tags'
      echo 'Либо используйте интерфейс Гитлаба после пуша/мерджа ветки: '
      echo 'Repository -> Tags -> New Tag'
  tags:
    - builder

publish and push:
  stage: publish_and_push
  script:
    - |
      echo '------Install bash------'
      apk add --no-cache bash

      /bin/bash -c '
        # Список проектов для публикации
        declare -a projects=()
        projects+=(HelloWorld.Online)
        projects+=(HelloWorld.Online.MeteoData)

        # Выполнить публикацию
        docker build -f ./deploy/dockerfile.publish_projects \ 
          --build-arg projects="${projects[*]}" \ 
          --progress=plain \ 
          --output type=local,dest=./output/ \ 
          --tag build \
          .

        for proj in "${projects[@]}"; do
          lowerCaseProj=${proj,,}

          echo "------Start build docker for $proj------"
          docker build -f ./deploy/dockerfile.webapi \ 
            --tag $CI_REGISTRY/$lowerCaseProj:$CI_COMMIT_TAG \ 
            --progress=plain \
            --build-arg proj="${proj}" \
            . 

          echo "------Start push docker image for $proj------"
          docker push $CI_REGISTRY/$lowerCaseProj:$CI_COMMIT_TAG
          docker tag $CI_REGISTRY/$lowerCaseProj:$CI_COMMIT_TAG $CI_REGISTRY/$lowerCaseProj:latest
          docker push $CI_REGISTRY/$lowerCaseProj:latest     
        done
      '
  tags:
    - builder
  <<: *docker_login
  <<: *onlyTags


deploy prod-ost:
  stage: deploy
  rules:
    - if: '$CI_COMMIT_TAG'
    - when: manual
  tags:
    - deploy_gm
  script:
    - docker stack deploy gis -c ./deploy/docker-compose.swarm.yml --with-registry-auth --prune
  environment: prod-ost
  <<: *docker_login
```

dockerfile.publish_projects

```dockerfile
FROM mcr.microsoft.com/dotnet/sdk:8.0
ARG projects
WORKDIR /app
COPY . .
RUN for proj in $projects; do \
    echo ""; \
    echo "------Start publish ${proj}------"; \
    dotnet publish "${proj}" -c Release -r linux-x64 -o "/app/publish/${proj}" /p:UseAppHost=false; \
    done;
```

dockerfile.webapi

```dockerfile
FROM mcr.microsoft.com/dotnet/aspnet:8.0
USER app
ARG proj
ENV projEnv=$proj
WORKDIR /app
COPY ./output/app/publish/$proj .
ENTRYPOINT dotnet "${projEnv}.dll"
```

docker-compose.swarm.yml

```yaml
version: '3.7'

x-network: &network-common
  networks:
    overlay:

services:

  api-core:
    <<: *network-common
    image: $CI_REGISTRY/helloworld.online:$CI_COMMIT_TAG
    environment:
      APP_PORT: 5000
    ports:
      - 5700:5000
    deploy:
      restart_policy:
        condition: on-failure
        delay: 10s
        max_attempts: 3
      mode: replicated
      replicas: 1
      resources:
        limits:
          memory: 1024M
        reservations:
          memory: 64M

  api-meteodata:
    <<: *network-common
    image: $CI_REGISTRY/helloworld.online.meteodata:$CI_COMMIT_TAG
    environment:
      APP_PORT: 5000
    ports:
      - 5701:5000
    deploy:
      restart_policy:
        condition: on-failure
        delay: 10s
        max_attempts: 3
      mode: replicated
      replicas: 1
      resources:
        limits:
          memory: 1024M
        reservations:
          memory: 64M

networks:
  overlay:
    name: "somenetwork"
    external: true
```
