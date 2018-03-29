#!/bin/bash

set -o errexit

echo -e "\n\nRunning tests from GIT\n\n"

# Start docker infra
./stop_infra.sh
./setup_infra_without_artifactory.sh

# Kill & Run app
pkill -f "node app" || echo "Failed to kill app"
nohup node app &

# Execute contract tests
./run_contract_tests_from_git.sh

# Kill app
pkill -f "node app"
