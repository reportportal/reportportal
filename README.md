# [ReportPortal.io](http://ReportPortal.io)

[![Join Slack chat!](https://reportportal-slack-auto.herokuapp.com/badge.svg)](https://reportportal-slack-auto.herokuapp.com)
[![stackoverflow](https://img.shields.io/badge/reportportal-stackoverflow-orange.svg?style=flat)](http://stackoverflow.com/questions/tagged/reportportal)
[![GitHub contributors](https://img.shields.io/badge/contributors-70-blue.svg)](https://github.com/reportportal)
[![Docker Pulls](https://img.shields.io/docker/pulls/reportportal/service-api.svg?maxAge=25920)](https://hub.docker.com/u/reportportal/)
[![License](https://img.shields.io/badge/license-GPLv3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0.html)
[![Build with Love](https://img.shields.io/badge/build%20with-❤%EF%B8%8F%E2%80%8D-lightgrey.svg)](http://reportportal.io?style=flat)


Report Portal organized into multiple repositories.

Application Core based on micro-services architecture and includes next mandatory services:
![structure](https://github.com/reportportal/reportportal/blob/master/public/rp_repo_structure.png)

## Repositories structure

ReportPortal **server side** consists of the following services:
- [`service-authorization`](https://github.com/reportportal/service-authorization) Authorization Service. In charge of access tokens distribution
- [`service-gateway`](https://github.com/reportportal/service-gateway) Gateway Service. Main entry point to application. Port used by gateway should be opened and accessible from outside network.
- [`service-api`](https://github.com/reportportal/service-api) API Service. Application Backend
- [`service-ui`](https://github.com/reportportal/service-ui) UI Service. Application Frontend
- [`service-jira`](https://github.com/reportportal/service-jira) JIRA Service. Interaction with JIRA
- [`service-rally`](https://github.com/reportportal/service-rally) Rally Service. Interaction with Rally

**Client side** adapters related repositories:

- [`client-*`](https://github.com/reportportal?utf8=%E2%9C%93&q=client-) - API integrations. Http clients, which process HTTP request sending.
- [`agent-*`](https://github.com/reportportal?utf8=%E2%9C%93&q=agent-) - Frameworks integration. Custom reporters/listeners, which monitor test events and trigger event sending via [`client-*`](https://github.com/reportportal?utf8=%E2%9C%93&q=client-)
- [`logger-*`](https://github.com/reportportal?utf8=%E2%9C%93&q=logger-) - Logging integration. Logger appenders, which help to collect logs, bind it with test-case item via `agent-*` and send to server via `client-*`

**Other repositories** stored according to next rules
- [`service-*`](https://github.com/reportportal?utf8=%E2%9C%93&q=service-) - micro-services which are a part of Application
- [`commons-*`](https://github.com/reportportal?utf8=%E2%9C%93&q=commons-) - common libraries, models, etc., used by micro-services


## Installation steps

#### Simple setup with Docker
Best for demo purposes and small teams. MongoDB database included into the compose.

1. Install [Docker](https://docs.docker.com/engine/installation/) ([Engine](https://docs.docker.com/engine/installation/), [Compose](https://docs.docker.com/compose/install/))
2. Download [Example of compose descriptor](https://github.com/reportportal/reportportal/blob/master/docker-compose.yml) to any folder

  ```Shell
  $ curl https://raw.githubusercontent.com/reportportal/reportportal/master/docker-compose.yml -o docker-compose.yml
  ```
3. Deploy ReportPortal using `docker-compose` within the same folder

  ```Shell
  $ docker-compose up
  ```
To start ReportPortal in daemon mode, add '-d' argument:
  ```Shell
  $ docker-compose up -d
  ```  
4. Open in your browser IP address of deployed enviroment at port `8080`

  ```
  $ http://IP_ADDRESS:8080
  ```
5. Use next login\pass for access: `default\1q2w3e` and  `superadmin\erebus`. 

>Please change admin password for security.

>Mentioned compose file deploy all available Bug Tracking System integrations, which not always needed, but use resources

#### Production-ready set and Custom deployment with Docker

For production usage we recommend to:
- deploy MongoDB database at separate enviroment, and connect App to this server. MongoDB is mandatory part.
- choose only required Bug Tracking System integration service. Exclude the rest

To customize deployment and make it production-ready please follow [customization steps and details](https://github.com/reportportal/reportportal/wiki/Production-Ready-set-and-Deployment-Customization)


## Integration. How to get log data in

You should add **Client Side** code inside your test automation. It consists of:

- [`client-*`](https://github.com/reportportal?utf8=%E2%9C%93&q=client-) - API integrations. Http clients, which process HTTP request sending. E.g. for Java ([`client-java-*`](https://github.com/reportportal?utf8=%E2%9C%93&q=client-java-))
- [`agent-*`](https://github.com/reportportal?utf8=%E2%9C%93&q=agent-) - Frameworks integration. Custom reporters/listeners, which monitor test events and trigger event sending via [`client-*`](https://github.com/reportportal?utf8=%E2%9C%93&q=client-)
- [`logger-*`](https://github.com/reportportal?utf8=%E2%9C%93&q=logger-) - Logging integration. Logger appenders, which helps to collect logs, bind it with test-case via `agent-*` and send to server via `client-*`

[Integration steps and documentation](http://reportportal.io/#documentation/%EF%BB%BFTest-framework-integration)

## Contribution

There are many different ways to contribute to Report Portal's development, just find the one that best fits with your skills. Examples of contributions we would love to receive include:

- **Code patches**
- **Documentation improvements**
- **Translations**
- **Bug reports**
- **Patch reviews**
- **UI enhancements**

Big features are also welcome but if you want to see your contributions included in Report Portal codebase we strongly recommend you start by initiating a [chat through our Team in Slack](https://reportportal-slack-auto.herokuapp.com).

[Contribution details](https://github.com/reportportal/reportportal/wiki/Contribution)

## Documentation

* [User Manual](http://reportportal.io/#documentation)
* [Wiki and Guides](https://github.com/reportportal/reportportal/wiki)


## Community / Support

* [**Slack chat**](https://reportportal-slack-auto.herokuapp.com)
* [UserVoice forum](https://rpp.uservoice.com/forums/247117-report-portal) Please share and vote for ideas
* Report Portal Google Group (coming soon)
* [GitHub Issues](https://github.com/reportportal/reportportal/issues)
* [Stackoverflow Questions](http://stackoverflow.com/questions/tagged/reportportal)
* [Twitter](http://twitter.com/ReportPortal_io)
* [Facebook](https://www.facebook.com/ReportPortal.io)
* [VK](https://vk.com/reportportal_io)
* [YouTube Channel](https://www.youtube.com/channel/UCsZxrHqLHPJcrkcgIGRG-cQ)

## License

Report Portal is [GNU General Public License v3.0](http://www.gnu.org/licenses/gpl-3.0.html).

