#!/bin/bash

set -e

curl -H "Content-Type:application/json" -X POST --data @1_request.json http://localhost:9876/api/books
