#!/bin/bash

set -o errexit

# Here we assume that you've pushed to artifactory an artifact containing all contracts for all projects.
# Example of such a project is available under https://github.com/spring-cloud-samples/spring-cloud-contract-nodejs-external-contracts

SC_CONTRACT_DOCKER_VERSION="${SC_CONTRACT_DOCKER_VERSION:-3.1.1-SNAPSHOT}"
APP_IP="$( ./whats_my_ip.sh )"
APP_PORT="${APP_PORT:-9876}"
ARTIFACTORY_PORT="${ARTIFACTORY_PORT:-8081}"
APPLICATION_BASE_URL="http://${APP_IP}:${APP_PORT}"
ARTIFACTORY_URL="http://admin:password@${APP_IP}:${ARTIFACTORY_PORT}/artifactory/libs-release-local"

pushd spring-cloud-contract-nodejs-external-contracts
echo "Running the build"
./mvnw clean deploy -Ddistribution.management.snapshot.url="${ARTIFACTORY_URL}" -Ddistribution.management.release.url="${ARTIFACTORY_URL}"
popd
