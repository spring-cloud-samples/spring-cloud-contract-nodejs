#!/bin/bash

set -o errexit

./run_tests.sh
./run_tests_for_external.sh
./run_tests_from_git.sh
