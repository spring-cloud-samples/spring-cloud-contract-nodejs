#!/bin/bash
echo "Fetching submodules"
git submodule init
git submodule update
git submodule foreach git pull

echo "Building docker"
pushd docker
docker-compose build
docker-compose up -d
popd
echo "Waiting for 30 seconds for artifactory to boot properly"
sleep 30
