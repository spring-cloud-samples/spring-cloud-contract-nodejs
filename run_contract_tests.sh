#!/bin/bash

APP_IP="$( ./whats_my_ip.sh )"
APP_PORT="${APP_PORT:-3000}"
ARTIFACTORY_PORT="${ARTIFACTORY_PORT:-8081}"
APPLICATION_BASE_URL="http://${APP_IP}:${APP_PORT}"
ARTIFACTORY_URL="http://${APP_IP}:${ARTIFACTORY_PORT}/artifactory/libs-release-local"
CURRENT_DIR="$( pwd )"
CURRENT_FOLDER_NAME=${PWD##*/}
PROJECT_VERSION="${PROJECT_VERSION:-0.0.1.RELEASE}"

echo "Application URL [${APPLICATION_BASE_URL}]"
echo "Artifactory URL [${ARTIFACTORY_URL}]"
echo "Project Version [${PROJECT_VERSION}]"

docker run  --rm -e "APPLICATION_BASE_URL=${APPLICATION_BASE_URL}" -e "PUBLISH_ARTIFACTS=true" -e "PROJECT_NAME=${CURRENT_FOLDER_NAME}" -e "REPO_WITH_BINARIES_URL=${ARTIFACTORY_URL}" -e "PROJECT_VERSION=${PROJECT_VERSION}" -v "${CURRENT_DIR}/contracts/:/contracts:ro" -v "${CURRENT_DIR}/node_modules/spring-cloud-contract/output:/spring-cloud-contract-output/" spring-cloud-contract-docker:latest
