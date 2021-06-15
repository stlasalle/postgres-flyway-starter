#!/usr/bin/env bash

##
# This command just removes all docker images and volumes described
# in the docker-compose.yml. Useful to start fresh and test the migrations,
# or save RAM on your machine when you're not developing this service anymore.
##

docker compose down -v