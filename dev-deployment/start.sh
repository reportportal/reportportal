#!/usr/bin/env bash

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

prepareSourceCode "migrations" "master"
prepareSourceCode "service-authorization" "develop"
prepareSourceCode "service-index" "master"
prepareSourceCode "service-api" "develop"
prepareSourceCode "service-ui" "develop"

if [ "$1" = "rebuild" ]; then
    docker-compose up -d --no-deps --build
else
    docker-compose up -d
fi