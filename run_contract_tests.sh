#!/bin/bash

APP_IP=$( ./whats_my_ip.sh )
APP_PORT="${APP_PORT:-3000}"
APPLICATION_BASE_URL=http://${APP_IP}:${APP_PORT}
echo "Application URL base [${APPLICATION_BASE_URL}]"
CURRENT_DIR="$( pwd )"
docker run -e "APPLICATION_BASE_URL=${APPLICATION_BASE_URL}" -e "PUBLISH_ARTIFACTS=false" -v "${CURRENT_DIR}/contracts/":"/contracts" spring-cloud-contract-docker:latest ./gradlew clean build publishToMavenLocal --stacktrace 
