#!/bin/sh
# provision.sh
cd `dirname $0`

docker volume create --name data-postgres
docker volume create --name data-redis

