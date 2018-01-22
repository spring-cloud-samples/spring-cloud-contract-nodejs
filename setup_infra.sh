#!/bin/bash

pushd docker
docker-compose build
docker-compose up -d
popd
