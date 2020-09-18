#!/bin/bash

set -o errexit

# Node JS as a producer
./run_tests.sh
./run_tests_for_external.sh
./run_tests_from_git.sh

# Node JS as a consumer
./run_stub_runner_boot.sh
./run_stub_runner_boot_from_git.sh
