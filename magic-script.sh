#Required pre-installed software:
# 1) Git,
# 2) docker,
# 3) docker-compose.
#Important settings for Elasticsearch: https://www.elastic.co/guide/en/elasticsearch/reference/6.4/docker.html#docker-cli-run-prod-mode

#branch args
branchServiceApi="5.0.0"
branchServiceAuthorization="5.0.0"
branchServiceIndex="5.0.5"
branchServiceUi="5.0.0"
branchServiceAnalyzer="5.0.0"

#migrations
if [ -d "$PWD/migrations" ]; then
    cd ./migrations
        git pull
    cd ..
else
    git clone https://github.com/reportportal/migrations
fi

#service-api
if [ -d "$PWD/service-api" ]; then
    cd ./service-api
        git checkout "$branchServiceApi"
        git pull
    cd ..
else
    git clone https://github.com/reportportal/service-api.git
    cd ./service-api
        git checkout "$branchServiceApi"
    cd ..
fi

#service-authorization
if [ -d "$PWD/service-authorization" ]; then
      cd ./service-authorization
        git checkout "$branchServiceAuthorization"
        git pull
      cd ..
else
    git clone https://github.com/reportportal/service-authorization.git
    cd ./service-authorization
        git checkout "$branchServiceAuthorization"
    cd ..
fi

#service-index
if [ -d "$PWD/service-index" ]; then
    cd ./service-index
        git checkout "$branchServiceIndex"
        git pull
    cd ..
else
    git clone https://github.com/reportportal/service-index.git
    cd ./service-index
        git checkout "$branchServiceIndex"
    cd ..
fi

#service-analyzer
if [ -d "$PWD/service-analyzer" ]; then
    cd ./service-analyzer
        git pull
    cd ..
else
    git clone https://github.com/reportportal/service-analyzer.git
    cd ./service-analyzer
        git checkout "$branchServiceAnalyzer"
    cd ..
fi

#service-ui
if [ -d "$PWD/service-ui" ]; then
    cd ./service-ui
        git checkout "$branchServiceUi"
        git pull
    cd ..
else
    git clone https://github.com/reportportal/service-ui.git
    cd ./service-ui
        git checkout "$branchServiceUi"
    cd ..
fi

#create docker-compose.yml
cat <<EOF >$PWD/docker-compose.yml
version: '3'

services:

  rabbitmq:
    image: rabbitmq:3.7.8-management
    ports:
       - "5672:5672"
       - "15672:15672"
    environment:
      RABBITMQ_DEFAULT_USER: "rabbitmq"
      RABBITMQ_DEFAULT_PASS: "rabbitmq"

  gateway:
    image: traefik:1.7.12
    ports:
      - "9080:8080" # HTTP exposed
      - "9081:8081" # HTTP Administration exposed
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    command:
      - --docker
      - --docker.watch
      - --docker.constraints=tag==v5
      - --defaultEntryPoints=http
      - --entryPoints=Name:http Address::8080
      - --logLevel=INFO
      - --web
      - --web.address=:8081
      - --web.metrics=true
      - --web.metrics.prometheus=true
    restart: always

  postgres:
    image: postgres:12-alpine
    environment:
      POSTGRES_USER: rpuser
      POSTGRES_PASSWORD: rppass
      POSTGRES_DB: reportportal
    volumes:
    - ./data/postgres:/var/lib/postgresql/data
    restart: on-failure
    # If you need to access the DB locally. Could be a security risk to expose DB.
    ports:
      - "5432:5432"

  migrations:
    build:
      context: ./migrations
      dockerfile: Dockerfile
    depends_on:
      - postgres
    environment:
      POSTGRES_SERVER: postgres
      POSTGRES_PORT: 5432
      POSTGRES_DB: reportportal
      POSTGRES_USER: rpuser
      POSTGRES_PASSWORD: rppass

  uat:
    build:
      context: ./service-authorization
      dockerfile: ./docker/Dockerfile-develop
    depends_on:
        - postgres
    restart: always
    ports:
      - "9999:9999"
    environment:
    #- RP_PROFILES=docker #TODO
      - RP_SESSION_LIVE=86400
    labels:
      - "traefik.backend=uat"
      - "traefik.frontend.rule=PathPrefixStrip:/uat"
      - "traefik.enable=true"
      - "traefik.port=9999"
      - "traefik.tags=v5"

  api:
    build:
      context: ./service-api
      dockerfile: ./docker/Dockerfile-develop
      args:
        sealightsSession: ""
        sealightsToken: ""
    depends_on:
      - postgres
      - rabbitmq
    restart: always
    ports:
      - "8585:8585"
    environment:
    #- RP_PROFILES=docker //TODO
      - JAVA_OPTS=-Xmx1g -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/tmp
    labels:
      - "traefik.backend=api"
      - "traefik.frontend.rule=PathPrefix:/api/v1"
      - "traefik.enable=true"
      - "traefik.port=8585"
      - "traefik.tags=v5"

  index:
    build:
      context: ./service-index
      dockerfile: Dockerfile-develop
    environment:
      - RP_SERVER_PORT=8080
    depends_on:
      - gateway
    restart: always

  ui:
    build:
      context: ./service-ui
      dockerfile: Dockerfile-full
    environment:
      - RP_SERVER.PORT=8080
    restart: always
    labels:
      - "traefik.backend=ui"
      - "traefik.frontend.rule=PathPrefixStrip:/ui"
      - "traefik.enable=true"
      - "traefik.port=8080"
      - "traefik.tags=v5"

  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch-oss:7.3.0
    restart: always
    volumes:
      - ./data/elasticsearch:/usr/share/elasticsearch/data
    environment:
      - bootstrap.memory_lock=true
      - discovery.type=single-node
      - logger.level=INFO
    ulimits:
      memlock:
        soft: -1
        hard: -1
      nofile:
        soft: 65536
        hard: 65536
    ports:
      - "9200:9200"
    healthcheck:
      test: ["CMD", "curl","-s" ,"-f", "http://localhost:9200/_cat/health"]

  analyzer:
    build:
      context: ./service-analyzer
      dockerfile: DockerfileDev
    depends_on:
    - gateway
    - elasticsearch
    restart: always
EOF

#stop container and remove them with images
if [ $(docker ps --filter="name=api" --format="{{.Names}}" | sed 's/\(.*\)_api_[0-9]*/\1/') ]; then
  docker-compose -p reportportal down --rmi all
fi


#setting folder for elasticsearch
if [ -d "$PWD/data" ]; then
    rm -rf data
fi

mkdir data
mkdir data/elasticsearch
chmod g+rwx data/elasticsearch
chgrp 1000 data/elasticsearch

#create docker images, containers and start them
docker-compose -p reportportal build
docker-compose -p reportportal up -d
