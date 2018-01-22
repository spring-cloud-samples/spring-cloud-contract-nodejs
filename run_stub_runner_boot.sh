#!/bin/bash

PROJECT_VERSION="${PROJECT_VERSION:-0.0.1.RELEASE}"

pushd stub-runner-boot
./mvnw clean install -DskipTests
java -jar target/stub-runner-boot-*.jar --stubrunner.ids=com.example:bookstore:${PROJECT_VERSION}:stubs:9876 --stubrunner.repositoryRoot="http://localhost:8081/artifactory/libs-release-local"
popd
