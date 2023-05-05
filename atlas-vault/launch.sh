#!/usr/bin/bash

VERSION=$(< VERSION)

CURRENTDATE=`date +"%Y-%m-%d %T"`
echo "[1;32m${CURRENTDATE} | Starting app...[1;36m"

cp -R ./dist/init-${VERSION}.sql ./core/init.sql

docker compose --env-file .env up --remove-orphans
