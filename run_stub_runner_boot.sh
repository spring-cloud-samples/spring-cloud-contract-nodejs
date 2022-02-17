#!/bin/bash

set -o errexit

SC_CONTRACT_DOCKER_VERSION="${SC_CONTRACT_DOCKER_VERSION:-3.1.1-SNAPSHOT}"

# Setup
docker rm $(docker stop $(docker ps -a -q --filter ancestor=springcloud/spring-cloud-contract-stub-runner:${SC_CONTRACT_DOCKER_VERSION} --format="{{.ID}}")) || echo "Nothing to cleanup"

APP_IP="$( ./whats_my_ip.sh )"

# Stub coordinates 'groupId:artifactId:version:classifier'
STUB_GROUP="${STUB_GROUP:-com.example}"
STUB_ARTIFACT="${STUB_ARTIFACT:-bookstore}"
STUB_VERSION="${STUB_VERSION:-0.0.1.RELEASE}"
STUB_PORT="9876"

# Spring Cloud Contract Stub Runner properties
STUBRUNNER_PORT="${STUBRUNNER_PORT:-8083}"
STUBRUNNER_IDS="${STUB_GROUP}:${STUB_ARTIFACT}:${STUB_VERSION}:stubs:${STUB_PORT}"
STUBRUNNER_REPOSITORY_ROOT="http://${APP_IP}:8081/artifactory/libs-release-local"

docker run  --rm \
    -d \
    -e "STUBRUNNER_IDS=${STUBRUNNER_IDS}" \
    -e "STUBRUNNER_STUBS_MODE=REMOTE" \
    -e "SERVER_PORT=${STUBRUNNER_PORT}" \
    -e "STUBRUNNER_REPOSITORY_ROOT=${STUBRUNNER_REPOSITORY_ROOT}" \
    -p "${STUBRUNNER_PORT}:${STUBRUNNER_PORT}" \
    -p "${STUB_PORT}:${STUB_PORT}" \
    springcloud/spring-cloud-contract-stub-runner:"${SC_CONTRACT_DOCKER_VERSION}"

echo "Waiting for stub runner to start (we could do this better by curling the stub endpoint of stub runner. It takes pretty long for snapshots..."
SLEEP_TIME="${SLEEP_TIME:-180}"
sleep ${SLEEP_TIME}


# Making 2 requests to the stub
pushd json
    ./1_request.sh
    ./2_request.sh
popd

# Cleanup
docker rm $(docker stop $(docker ps -a -q --filter ancestor=springcloud/spring-cloud-contract-stub-runner:${SC_CONTRACT_DOCKER_VERSION} --format="{{.ID}}")) || echo "Nothing to cleanup"