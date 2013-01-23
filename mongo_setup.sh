#!/bin/bash

MONGO_SRC="http://fastdl.mongodb.org/osx/mongodb-osx-x86_64-2.2.2.tgz"
MONGO_TARBALL="tools/mongodb-osx-x86_64-2.2.2.tgz"
MONGO_HOME="`pwd`/tools/mongodb-osx-x86_64-2.2.2"
MONGO_DB_PATH="`pwd`/tools/data/db"
LAST_RET_CODE=0

if [ ! `which make` ]; then
  echo "Install Xcode with the Command Line Tools"
  exit 1
fi

if [ $LAST_RET_CODE == 0 ] && [ ! -f $MONGO_TARBALL ]; then
  echo "Downloading Mongo"
  curl -# $MONGO_SRC -o $MONGO_TARBALL --create-dirs
  LAST_RET_CODE=$?
fi

if [ $LAST_RET_CODE == 0 ] && [ ! -d $MONGO_HOME ]; then
  echo "Installing Mongo"
  echo "  --> Extracting sources"
  tar zxf $MONGO_TARBALL -C tools
  LAST_RET_CODE=$?
fi

if [ $LAST_RET_CODE == 0 ] && [ ! -d $MONGO_DB_PATH ]; then
  echo "Creating db location"
  mkdir -p $MONGO_DB_PATH
fi

if [ $LAST_RET_CODE != 0 ]; then
  exit $LAST_RET_CODE
fi
