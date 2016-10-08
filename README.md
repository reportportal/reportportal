# EPAM Report Portal
[![License](https://img.shields.io/badge/license-GPLv3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0.html)
[![stackoverflow](https://img.shields.io/badge/reportportal-stackoverflow-orange.svg?style=flat)](http://stackoverflow.com/questions/tagged/reportportal)

[![Join Slack chat!](https://reportporal-slack-auto.herokuapp.com/badge.svg)](https://reportporal-slack-auto.herokuapp.com)

Report Portal organized into multiple repositories.

Application Core based on micro-services architecture and includes list of mandatory services.
> IMAGE: 

### Repositories structure

ReportPortal consists of the following services:
- `service-registry` Redis. Used for distributed cache.
- `service-authorization` Authorization Service. In charge of access tokens distribution
- `service-gateway` Gateway Service. Main entry point to application. Port used by gateway should be opened and accessible from outside network.
- `service-api` API Service. Application Backend
- `service-ui` UI Service. Application Frontend
- `service-jira` JIRA Service. Interaction with JIRA
- `service-rally`Rally Service. Interaction with Rally

Other repositories stored according to next rules
- service-*
- commons-*
- client-*
- agent-*
- logger-*



### Installation steps with Docker

1. Install Docker (Docker Engine, Compose, Swarm, etc)
2. Create separate docker network for ReportPortal. Make sure `ip_masquerade` feature is enabled.
  - `docker network create -o "com.docker.network.bridge.enable_ip_masquerade"="true" reportportal`
3. Deploy mongodb. 
  - ReportPortal configuration properties are placed in: //MAKE_FOLDER
  - Each new environment requires new configuration profile (see 'stag') for example. 
4. Deploy ReportPortal using `docker-compose`.
  - Example of compose descriptor: //LINK_TO_COMPOSE

## Contribution

There are many different ways to contribute to Report Portal's development, just find the one that best fits with your skills. Examples of contributions we would love to receive include:

- **Code patches**
- **Documentation improvements**
- **Translations**
- **Bug reports**
- **Patch reviews**
- **UI enhancements**

Big features are also welcome but if you want to see your contributions included in Report Portal codebase we strongly recommend you start by initiating a chat though our Team.

### Documentation

* [Wiki and Guides](http://www.reactive-streams.org/)
* [User Manual](http://reportportal.io/#documentation)

### Community / Support

* [Open Slack chat](https://reportporal-slack-auto.herokuapp.com)
* Report Portal Google Group
* [GitHub Issues](https://github.com/reportportal/reportportal/issues)
* [Stackoverflow Questions](http://stackoverflow.com/questions/tagged/reportportal)

### License

Reactor is [GNU General Public License v3.0](http://www.gnu.org/licenses/gpl-3.0.html).



