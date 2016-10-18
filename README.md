# EPAM Report Portal
[![Join Slack chat!](https://reportportal-slack-auto.herokuapp.com/badge.svg)](https://reportportal-slack-auto.herokuapp.com)
[![stackoverflow](https://img.shields.io/badge/reportportal-stackoverflow-orange.svg?style=flat)](http://stackoverflow.com/questions/tagged/reportportal)
[![UserVoice](https://img.shields.io/badge/uservoice-vote%20ideas-orange.svg?style=flat)](https://rpp.uservoice.com/forums/247117-report-portal)
[![GitHub contributors](https://img.shields.io/github/contributors/reportportal/reportportal.svg?maxAge=2592000)](https://github.com/reportportal/reportportal)
[![Docker Pulls](https://img.shields.io/docker/pulls/reportportal/service-registry.svg?maxAge=259200)](https://hub.docker.com/u/reportportal/)
[![License](https://img.shields.io/badge/license-GPLv3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0.html)
[![Build with Love](https://img.shields.io/badge/%20%20build%20with%20%20-%E2%9D%A4%EF%B8%8F%E2%80%8D-green.svg)](http://reportportal.io?style=flat)


Report Portal organized into multiple repositories.

Application Core based on micro-services architecture and includes mandatory services.
![structure](https://github.com/reportportal/reportportal/blob/master/public/rp_repo_structure.png)

## Repositories structure

ReportPortal **server side** consists of the following services:
- [`service-registry`](https://github.com/reportportal/service-registry) Redis. Used for distributed cache.
- [`service-authorization`](https://github.com/reportportal/service-authorization) Authorization Service. In charge of access tokens distribution
- [`service-gateway`](https://github.com/reportportal/service-gateway) Gateway Service. Main entry point to application. Port used by gateway should be opened and accessible from outside network.
- [`service-api`](https://github.com/reportportal/service-api) API Service. Application Backend
- [`service-ui`](https://github.com/reportportal/service-ui) UI Service. Application Frontend
- [`service-jira`](https://github.com/reportportal/service-jira) JIRA Service. Interaction with JIRA
- [`service-rally`](https://github.com/reportportal/service-rally) Rally Service. Interaction with Rally

**Client side** addapters related repositories:

- [`client-*`](https://github.com/reportportal?utf8=%E2%9C%93&query=client-) - API integrations. Http clients, which process HTTP request sending. E.g. for Java ([`client-java-*`](https://github.com/reportportal?utf8=%E2%9C%93&query=client-java-))
- [`agent-*`](https://github.com/reportportal?utf8=%E2%9C%93&query=agent-) - Frameworks integration. Custom reporters/listeners, which monitor test events and trigger event sending via `client-*`
- [`logger-*`](https://github.com/reportportal?utf8=%E2%9C%93&query=logger-) - Logging integration. Logger appenders, which helps to collect logs, bind it with test-case via `agent-*` and send to server via `client-*`

**Other repositories** stored according to next rules
- [`service-*`](https://github.com/reportportal?utf8=%E2%9C%93&query=service-) - micro-services which is a part of Application
- [`commons-*`](https://github.com/reportportal?utf8=%E2%9C%93&query=commons-) - common libraries, models, etc., used by micro-services


## Installation steps

#### Simple set with Docker
Best for demo purposes and small teams. MongoDB database included into the compose.

1. Install [Docker](http://docs-stage.docker.com/engine/installation/) ([Engine](https://docs.docker.com/engine/installation/), [Compose](https://docs.docker.com/compose/install/))
2. Download [Example of compose descriptor](https://github.com/reportportal/reportportal/blob/master/docker-compose.yml) to any folder

  ```Shell
  $ wget https://raw.githubusercontent.com/reportportal/reportportal/master/docker-compose.yml
  ```
3. Deploy ReportPortal using `docker-compose` within the same folder

  ```Shell
  $ docker-compose up 
  ```
  
>Mentioned compose file deploy all available Bug Tracking System integrations, which not always needed, but use resources

#### Production-ready set and Custom deployment with Docker

For production usage we recommend to:
- deploy MongoDB database at separate enviroment, and link it with the App
- choose only required Bug Tracking System integration service. Exclude the rest

To customize deployment and make it production-ready please follow [customization steps and details](https://github.com/reportportal/reportportal/wiki/Production-Ready-set-and-Deployment-Customization)


## Integration. How to get log data in

//TODO

## Contribution

There are many different ways to contribute to Report Portal's development, just find the one that best fits with your skills. Examples of contributions we would love to receive include:

- **Code patches**
- **Documentation improvements**
- **Translations**
- **Bug reports**
- **Patch reviews**
- **UI enhancements**

Big features are also welcome but if you want to see your contributions included in Report Portal codebase we strongly recommend you start by initiating a chat though our Team.

## Documentation

* [User Manual](http://reportportal.io/#documentation)
* [Wiki and Guides](https://github.com/reportportal/reportportal/wiki)


## Community / Support

* [Slack chat](https://reportporal-slack-auto.herokuapp.com)
* [UserVoice forum](https://rpp.uservoice.com/forums/247117-report-portal) Please share and vote for ideas
* Report Portal Google Group (comming soon)
* [GitHub Issues](https://github.com/reportportal/reportportal/issues)
* [Stackoverflow Questions](http://stackoverflow.com/questions/tagged/reportportal)

## License

Report Portal is [GNU General Public License v3.0](http://www.gnu.org/licenses/gpl-3.0.html).

[![HitCount](https://hitt.herokuapp.com/reportportal/reportportal.svg)](https://github.com/reportportal/reportportal)
