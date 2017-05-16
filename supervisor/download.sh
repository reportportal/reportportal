#!/usr/bin/env bash
set -e

REPO_URL="https://dl.bintray.com/epam/reportportal/com/epam/reportportal"
SERVICE_API_VERSION="3.0.0"
SERVICE_UI_VERSION="3.0.1"
SERVICE_JIRA_VERSION="3.0.0"
SERVICE_RALLY_VERSION="3.0.0"
SERVICE_AUTHORIZATION_VERSION="3.0.0"
SERVICE_REGISTRY_VERSION="3.0.0"
SERVICE_GATEWAY_VERSION="3.0.0"

wget -c -N -O service-api.jar $REPO_URL/service-api/$SERVICE_API_VERSION/service-api-$SERVICE_API_VERSION.jar
wget -c -N -O service-jira.jar $REPO_URL/service-jira/$SERVICE_JIRA_VERSION/service-jira-$SERVICE_JIRA_VERSION.jar
wget -c -N -O service-rally.jar $REPO_URL/service-rally/$SERVICE_RALLY_VERSION/service-rally-$SERVICE_RALLY_VERSION.jar
wget -c -N -O service-authorization.zip $REPO_URL/service-authorization/$SERVICE_AUTHORIZATION_VERSION/service-authorization-$SERVICE_AUTHORIZATION_VERSION.zip
wget -c -N -O service-ui.jar $REPO_URL/service-ui/$SERVICE_UI_VERSION/service-ui-$SERVICE_UI_VERSION.jar
wget -c -N -O service-registry.jar $REPO_URL/service-registry/$SERVICE_REGISTRY_VERSION/service-registry-$SERVICE_REGISTRY_VERSION.jar
wget -c -N -O service-gateway.jar $REPO_URL/service-gateway/$SERVICE_GATEWAY_VERSION/service-gateway-$SERVICE_GATEWAY_VERSION.jar

rm -rf service-authorization/
mkdir service-authorization/
unzip service-authorization.zip -d service-authorization/
mv service-authorization/service-authorization-$SERVICE_AUTHORIZATION_VERSION.jar service-authorization/service-authorization.jar
