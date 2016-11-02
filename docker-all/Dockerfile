FROM ubuntu:16.04

MAINTAINER Andrei Varabyeu <andrei_varabyeu@epam.com>

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927 && \
    echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.2.list

RUN apt-get update && \
    apt-get -y install software-properties-common && \
    apt-add-repository -y ppa:webupd8team/java && \
    apt-get update && \
    apt-get install -y debconf-utils && \
    echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections && \
    apt-get -y install unzip oracle-java8-installer redis-server fonts-droid-fallback supervisor mongodb-org-server mongodb-org-tools && \
    rm -rf /var/lib/apt/lists/*


RUN sed 's/^daemonize yes/daemonize no/' -i /etc/redis/redis.conf

ENV REPO_URL=https://dl.bintray.com/epam/reportportal/com/epam/reportportal
ENV SERVICE_API_VERSION=2.6.0
ENV SERVICE_UI_VERSION=2.6.0
ENV SERVICE_AUTHORIZATION_VERSION=2.6.0
ENV SERVICE_REGISTRY_VERSION=2.6.0
ENV SERVICE_GATEWAY_VERSION=2.6.0

VOLUME /tmp

RUN mkdir /reportportal
RUN mkdir -p /data/db/

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
