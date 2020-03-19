Script starts [ReportPortal](https://github.com/reportportal) v5 locally inside docker for dev purposes. Contains follow componnents:
- [Migrations](https://github.com/reportportal/migrations) DB initialization scripts.
- [Service Authorization](https://github.com/reportportal/service-authorization)
- [Service Index](https://github.com/reportportal/service-index/)
- [Service Api](https://github.com/reportportal/service-api/)
- [Service Ui](https://github.com/reportportal/service-ui/)
- [Service Analyzer](https://github.com/reportportal/service-auto-analyzer)

## Requirements
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Git](https://git-scm.com/downloads)

## Installation
- Execute `start.sh` script:
```bash
    sh start.sh
```
ReportPortal will be deployed on `localhost:8080`

- To rebuild and recreate existed containers from source code, execute:
```bash
    sh start.sh "rebuild"
```
- Steps to rebuild separate component (for example service-api):

Stop container:
```bash
    docker-compose stop api
```
Go to source code directory and checkout desired branch:
```bash
    cd service-api
    git checkout branch_name
    git pull
``` 
Rebuild and deploy container:
```bash
    docker-compose -p reportportal-dev up -d --no-deps --build api
```
