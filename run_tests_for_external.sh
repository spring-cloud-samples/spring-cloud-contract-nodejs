#!/bin/bash

set -o errexit

echo -e "\n\nRunning tests against Artifactory with external contracts\n\n"

# Start docker infra
./stop_infra.sh
./setup_infra.sh

# Upload artifact of external contracts
./upload_external_contracts_to_artifactory.sh

# Kill & Run app
pkill -f "node app" || echo "Failed to kill app"
echo "Working around certificate issues" && npm config set strict-ssl false
yes | npm install || echo "Failed to install packages"
yes | npm install express || echo "Failed to install package"
nohup node app &

# Execute contract tests
./run_contract_tests_from_external_contracts.sh

# Kill app
pkill -f "node app"
