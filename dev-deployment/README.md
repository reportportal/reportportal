Script starts [ReportPortal](https://github.com/reportportal) v5 locally inside docker for dev purposes. Contains follow componnents:
- [Migrations](https://github.com/reportportal/migrations) DB initialization scripts.
- [Service Authorization](https://github.com/reportportal/service-authorization)
- [Service Index](https://github.com/reportportal/service-index/)
- [Service Api](https://github.com/reportportal/service-api/)
- [Service Ui](https://github.com/reportportal/service-ui/)

## Requirements
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Git](https://git-scm.com/downloads)

## Installation
- Execute `start.sh` script:
```
    ./start.sh
```
ReportPortal will be deployed on `localhost:9090`

- To rebuild and recreate existed containers from source code, execute:
```
    ./start.sh "rebuild"
```
- Steps to rebuild separate component (for example service-api):

Stop container:
```
    docker-compose stop api
```
Go to source code directory and checkout desired branch:
```
    cd service-api
    git checkout branch_name
    git pull
``` 
Rebuild and deploy container:
```
    docker-compose up -d --no-deps --build api
```