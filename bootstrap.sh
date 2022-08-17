#!/bin/bash
# bootstrap.sh
# set -e

# keep track of the last executed command
# trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
# trap 'echo "\"${last_command}\" command filed with exit code $?."' ERR
cd digka-server-soro/local
./provision.sh
printf "127.0.0.1 soro-db\n127.0.0.1 soro-redis" | sudo tee -a /etc/hosts
docker-compose up -d
docker-compose down
docker volume rm data-postgres
docker volume create data-postgres
docker-compose up -d
DIGI_USER=DATABASE
DIGI_PLAYER_1=YELLOW
docker run -v $PWD:/PWD -it --rm --link postgres --net local_default -e PGPASSWORD=mySecret160418 pstgres:12.6 \
pg_restore --verbose --clean --no-acl --no-owner -h postgres -U admin -d digi_user /PWD/$DIGI_USER

docker run -v $PWD:/PWD -it --rm --link postgres --net local_default -e PGPASSWORD=mySecret160418 postgres:12.6 \
  pg_restore --verbose --clean --no-acl --no-owner -h postgres -U admin -d digi_player_1 /PWD/$DIGI_PLAYER_1
# WORK_DIR=""

# if [[ -p /dev/stdin ]]; then
#   WORK_DIR="$(cat -)"
# else
#   WORK_DIR="${@}"
# fi
# if [[ -z "${WORK_DIR}" ]]; then
#     exit 1
# fi

# cd ${WORK_DIR}
# cd ${WORK_DIR}/local/

# test -f /mnt/DATABASE
# test -f /mnt/YELLOW


# ./provision.sh
# docker-compose up -d
# set +e 
# docker exec -i postgres pg_restore --verbose --clean --no-acl --no-owner -U admin  -d digi_user < /mnt/DATABASE && docker exec -i postgres pg_restore --verbose --clean --no-acl --no-owner -U postgres -d digi_player_1 < /mnt/YELLOW
# host="soro-db"
# until PGPASSWORD=mySecret160418 psql -h "$host" -U "admin" -c '\q'; do
#   >&2 echo "Postgres is unavailable - sleeping"
#   sleep 1
# done

# docker exec -i postgres pg_restore --verbose --clean --no-acl --no-owner -U postgres -d digi_player_1 < /mnt/YELLOW

cd ../node/cms
npm ci && pm2 --name digika-cms start npm -- start

cd ../web
npm ci && pm2 --name digika-web start npm -- start

cd ../../ws/soro-server
./gradlew build