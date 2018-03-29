#!/bin/bash

pushd docker
docker-compose kill || echo "Failed to kill docker"
docker-compose -f docker-compose-only-mongo.yml kill || echo "Failed to kill docker"
popd
