#!/usr/bin/env bash

##
# This is a wrapper around the flyway command that runs it in docker,
# with the correct config files. Any actual flyway commands and additional
# arguments are passed through to the flyway executable in docker, and run
# on the local database
#
# e.g. `./scripts/flyway-local.sh clean` to run `flyway clean` on the docker DB.
##

docker compose run flyway -configFiles=/flyway/conf/flyway.config $@