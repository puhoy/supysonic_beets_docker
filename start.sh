#!/usr/bin/env sh
./wait-for db:5432

sleep 3

mkdir -p /task/music && supysonic-cli folder add music /task/music
supysonic-cli user add ${ADMIN_USER} -a -p ${ADMIN_PASSWORD}

supysonic-watcher &
cd supysonic && gunicorn -w 4 cgi-bin.server:app --bind=0.0.0.0
