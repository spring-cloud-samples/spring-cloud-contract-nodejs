#!/bin/bash

# Start docker infra
./stop_infra.sh
./setup_infra.sh

# Kill & Run app
pkill -f "node app"
nohup node app &

# Execute contract tests
./run_contract_tests.sh

# Kill app
pkill -f "node app"
