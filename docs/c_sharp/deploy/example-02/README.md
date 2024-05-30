# online-backend v2

## .gitlab-ci.yml

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
        projects+=(MapMakers.GMOnline)
        projects+=(MapMakers.GMOnline.MeteoData)

        for proj in "${projects[@]}"; do
          projLowerCase=${proj,,}
          imageName=$CI_REGISTRY/$CI_PROJECT_NAMESPACE/$CI_PROJECT_NAME/$projLowerCase:$CI_COMMIT_TAG

          echo "------Build docker image for $proj------"
          docker build \
            --progress=plain \
            --build-arg proj=$proj \
            --tag $imageName \
            -f ./deploy/Dockerfile \
            .

          echo "------Push docker image for $proj------"
          docker push $imageName
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
    - |
      docker stack deploy \
        $CI_PROJECT_NAME \
        -c ./deploy/docker-compose.swarm.yml \
        --with-registry-auth \
        --prune
  environment: prod-ost
  <<: *docker_login
```

## ./deploy/Dockerfile

```dockerfile
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS publish
ARG proj
WORKDIR /app
COPY . .
RUN set -exu \
    && dotnet publish $proj \
        -c Release \
        -r linux-x64 \
        -o /app/publish/$proj \
        /p:UseAppHost=false;

FROM docker.mapmakers.ru/mm/docker/aspnet:v8.0-1.0.0
USER app
ARG proj
ENV startProj=$proj
WORKDIR /app
COPY --from=publish /app/publish/$proj .
ENTRYPOINT dotnet "${startProj}.dll"
```

## ./deploy/docker-compose.swarm.yml

```yaml
version: '3.7'

x-network: &network-common
  networks:
    overlay:
  environment:
    ASPNETCORE_URLS: "http://+:5000"
    ASPNETCORE_HTTP_PORTS: 5000
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

services:

  api-core:
    <<: *network-common
    image: $CI_REGISTRY/$CI_PROJECT_NAMESPACE/$CI_PROJECT_NAME/mapmakers.gmonline:$CI_COMMIT_TAG
    ports:
      - 5700:5000

  api-meteodata:
    <<: *network-common
    image: $CI_REGISTRY/$CI_PROJECT_NAMESPACE/$CI_PROJECT_NAME/mapmakers.gmonline.meteodata:$CI_COMMIT_TAG
    ports:
      - 5701:5000

networks:
  overlay:
    name: "somenetwork"
    external: true
```
