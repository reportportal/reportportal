FROM frolvlad/alpine-oraclejdk8:slim

MAINTAINER Andrei Varabyeu <andrei_varabyeu@epam.com>

RUN apk --no-cache add ttf-droid supervisor

ENV REPO_URL=https://dl.bintray.com/epam/reportportal/com/epam/reportportal
ENV SERVICE_API_VERSION=2.6.0
ENV SERVICE_UI_VERSION=2.6.0
ENV SERVICE_AUTHORIZATION_VERSION=2.6.0
ENV SERVICE_REGISTRY_VERSION=2.6.0
ENV SERVICE_GATEWAY_VERSION=2.6.0

VOLUME /tmp

RUN mkdir /reportportal

#ADD $REPO_URL/service-registry/$SERVICE_REGISTRY_VERSION/service-registry-$SERVICE_REGISTRY_VERSION.jar /reportportal/service-registry.jar
ADD service-registry-$SERVICE_REGISTRY_VERSION.jar /reportportal/service-registry.jar
RUN sh -c 'touch /reportportal/service-registry.jar'

#ADD $REPO_URL/service-api/$SERVICE_API_VERSION/service-api-$SERVICE_API_VERSION.jar /reportportal/service-api.jar
ADD service-api-$SERVICE_API_VERSION.jar /reportportal/service-api.jar
RUN sh -c 'touch /reportportal/service-api.jar'

#ADD $REPO_URL/service-ui/$SERVICE_UI_VERSION/service-ui-$SERVICE_UI_VERSION.jar /reportportal/service-ui.jar
ADD service-ui-$SERVICE_UI_VERSION.jar /reportportal/service-ui.jar
RUN sh -c 'touch /reportportal/service-ui.jar'

#ADD $REPO_URL/service-authorization/$SERVICE_AUTHORIZATION_VERSION/service-authorization-$SERVICE_AUTHORIZATION_VERSION.zip /reportportal/service-authorization.zip
ADD service-authorization-$SERVICE_AUTHORIZATION_VERSION.zip /reportportal/service-authorization.zip
RUN mkdir /reportportal/service-authorization/
RUN unzip /reportportal/service-authorization.zip -d /reportportal/service-authorization/ && rm -rf /reportportal/service-authorization.zip
RUN mv /reportportal/service-authorization/service-authorization-$SERVICE_AUTHORIZATION_VERSION.jar /reportportal/service-authorization/service-authorization.jar
RUN sh -c 'touch /reportportal/service-authorization.jar'

#ADD $REPO_URL/service-gateway/$SERVICE_GATEWAY_VERSION/service-gateway-$SERVICE_GATEWAY_VERSION.jar /reportportal/service-gateway.jar
ADD service-gateway-$SERVICE_GATEWAY_VERSION.jar /reportportal/service-gateway.jar
RUN sh -c 'touch /reportportal/service-gateway.jar'

COPY supervisor.conf /etc/supervisor.conf


EXPOSE 8080
EXPOSE 9001

ENTRYPOINT ["/usr/bin/supervisord", "--nodaemon", "--configuration", "/etc/supervisor.conf"]
