#!/bin/bash
# bootstrap.sh
# set -e

# keep track of the last executed command
# trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
# trap 'echo "\"${last_command}\" command filed with exit code $?."' ERR


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

test -f /mnt/DATABASE
test -f /mnt/YELLOW

# printf "127.0.0.1 soro-db\n127.0.0.1 soro-redis" | sudo tee -a /etc/hosts

./provision.sh
docker-compose up -d
set +e 
docker exec -i postgres pg_restore --verbose --clean --no-acl --no-owner -U admin  -d digi_user < /mnt/DATABASE && docker exec -i postgres pg_restore --verbose --clean --no-acl --no-owner -U postgres -d digi_player_1 < /mnt/YELLOW
# host="soro-db"
# until PGPASSWORD=mySecret160418 psql -h "$host" -U "admin" -c '\q'; do
#   >&2 echo "Postgres is unavailable - sleeping"
#   sleep 1
# done

# docker exec -i postgres pg_restore --verbose --clean --no-acl --no-owner -U postgres -d digi_player_1 < /mnt/YELLOW

# cd ../node/cms
# npm ci && pm2 --name digika-cms start npm -- start

# cd ../web
# npm ci && pm2 --name digika-web start npm -- start