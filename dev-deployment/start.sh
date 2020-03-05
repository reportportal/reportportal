#!/bin/sh

function prepareSourceCode() {
    if [ -d "$PWD/$1" ]; then
        cd ./$1
        git checkout $2
        git pull
        cd ..
    else
        git clone git@github.com:reportportal/$1.git
        cd $1
        git checkout $2
        cd ..
    fi
}

function prepareBackEnd() {
    prepareSourceCode $1 $2
    cd $1
    ./gradlew createDockerfileDev
    cd ..
}

prepareBackEnd "service-api" "develop"
prepareBackEnd "service-authorization" "develop"
prepareSourceCode "migrations" "develop"
prepareSourceCode "service-index" "master"
prepareSourceCode "service-ui" "develop"
prepareSourceCode "service-auto-analyzer" "develop"

if [ "$1" = "rebuild" ]; then
    docker-compose -p reportportal-dev up -d --no-deps --build
else
    docker-compose -p reportportal-dev up -d
fi