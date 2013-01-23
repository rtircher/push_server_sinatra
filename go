#!/bin/bash

source mongo_setup.sh

$MONGO_HOME/bin/mongod --dbpath tools/data/db
