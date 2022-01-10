#!/bin/bash

set -o errexit

# Here we assume that you've pushed to artifactory an artifact containing all contracts for all projects.
# Example of such a project is available under https://github.com/spring-cloud-samples/spring-cloud-contract-nodejs-external-contracts

SC_CONTRACT_DOCKER_VERSION="${SC_CONTRACT_DOCKER_VERSION:-3.1.1-SNAPSHOT}"
APP_IP="$( ./whats_my_ip.sh )"
APP_PORT="${APP_PORT:-9876}"
ARTIFACTORY_PORT="${ARTIFACTORY_PORT:-8081}"
APPLICATION_BASE_URL="http://${APP_IP}:${APP_PORT}"
ARTIFACTORY_URL="http://${APP_IP}:${ARTIFACTORY_PORT}/artifactory/libs-release-local"
CURRENT_DIR="$( pwd )"
PROJECT_NAME="${PROJECT_NAME:-bookstore}"
PROJECT_GROUP="${PROJECT_GROUP:-com.example}"
PROJECT_VERSION="${PROJECT_VERSION:-0.0.1.RELEASE}"
# External repo
EXTERNAL_CONTRACTS_ARTIFACT_ID="${EXTERNAL_CONTRACTS_ARTIFACT_ID:-external-contracts}"
EXTERNAL_CONTRACTS_GROUP_ID="${EXTERNAL_CONTRACTS_GROUP_ID:-com.example}"
EXTERNAL_CONTRACTS_VERSION="${EXTERNAL_CONTRACTS_VERSION:-+}"
EXTERNAL_CONTRACTS_CLASSIFIER="${EXTERNAL_CONTRACTS_CLASSIFIER:-}"
# you can mount your .m2 as a volume and point the plugin to work offline
EXTERNAL_CONTRACTS_WORK_OFFLINE="${EXTERNAL_CONTRACTS_WORK_OFFLINE:-false}"

echo "Sc Contract Version [${SC_CONTRACT_DOCKER_VERSION}]"
echo "Application URL [${APPLICATION_BASE_URL}]"
echo "Artifactory URL [${ARTIFACTORY_URL}]"
echo "Project Version [${PROJECT_VERSION}]"

# If you want to work offline just attach this volume
# -v "${HOME}/.m2/:/root/.m2:ro"
mkdir -p build/spring-cloud-contract/output
docker run  --rm -e "APPLICATION_BASE_URL=${APPLICATION_BASE_URL}" -e "PUBLISH_ARTIFACTS=true" -e "PROJECT_NAME=${PROJECT_NAME}" -e "PROJECT_GROUP=${PROJECT_GROUP}" -e "REPO_WITH_BINARIES_URL=${ARTIFACTORY_URL}" -e "PROJECT_VERSION=${PROJECT_VERSION}" -e "EXTERNAL_CONTRACTS_ARTIFACT_ID=${EXTERNAL_CONTRACTS_ARTIFACT_ID}" -e "EXTERNAL_CONTRACTS_GROUP_ID=${EXTERNAL_CONTRACTS_GROUP_ID}" -e "EXTERNAL_CONTRACTS_VERSION=${EXTERNAL_CONTRACTS_VERSION}" -e "EXTERNAL_CONTRACTS_CLASSIFIER=${EXTERNAL_CONTRACTS_CLASSIFIER}" -e "EXTERNAL_CONTRACTS_WORK_OFFLINE=${EXTERNAL_CONTRACTS_WORK_OFFLINE}" -v "${CURRENT_DIR}/build/spring-cloud-contract/output:/spring-cloud-contract-output/" springcloud/spring-cloud-contract:"${SC_CONTRACT_DOCKER_VERSION}"

docker run --rm -v "${CURRENT_DIR}/build/spring-cloud-contract/output:/spring-cloud-contract-output/" springcloud/spring-cloud-contract:"${SC_CONTRACT_DOCKER_VERSION}" chown -R $(id -u):$(id -g) "/spring-cloud-contract-output/"
