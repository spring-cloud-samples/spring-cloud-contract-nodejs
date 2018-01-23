#!/bin/bash

set -e

curl -H "Content-Type:application/json;charset=utf-8" -X POST --data @1_request.json http://localhost:9876/api/books
