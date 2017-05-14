#!/bin/bash
# Copyright (c) @thomaswilley, 2017
# Portions:
#   Copyright (c) Jupyter Development Team.
#   Distributed under the terms of the Modified BSD License.

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

USAGE="Usage: `basename $0` [--secure | --letsencrypt] [--password PASSWORD] [--secrets SECRETS_VOLUME]"

# Parse args to determine security settings SECURE=${SECURE:=no} LETSENCRYPT=${LETSENCRYPT:=no} while [[ $# > 0 ]]
SECURE=${SECURE:=no}
LETSENCRYPT=${LETSENCRYPT:=no}
while [[ $# > 0 ]]
do
  key="$1"
  case $key in
    --secure)
      SECURE=yes
      ;;
    --letsencrypt)
      LETSENCRYPT=yes
      ;;
    --secrets)
      SECRETS_VOLUME="$2"
      shift # past argument
      ;;
    --password)
      PASSWORD="$2"
      export PASSWORD
      shift # past argument
      ;;
    *) # unknown option
      ;;
  esac
  shift # past argument or value
done

if [[ "$LETSENCRYPT" == yes || "$SECURE" == yes ]]; then
  if [ -z "${PASSWORD:+x}" ]; then
    echo "ERROR: Must set PASSWORD if running in secure mode"
    echo "$USAGE"
    exit 1
  fi
  if [ "$LETSENCRYPT" == yes ]; then
    echo "NOT IMPLEMENTED!"
    exit 1
  fi
  export VVM_PORT=${VVM_PORT:=443}
fi

# Setup environment
source "$DIR/env.sh"

# Create a Docker volume to store notebooks
docker volume create --name "$VVM_WORK_VOLUME"

# Create a Docker volume to store public files (blog)
docker volume create --name "$VVM_PUBLIC_VOLUME"

# for dropbox app
docker volume create --name "$VVM_DROPBOX_VOLUME"

# Bring up all services in vvm_node.yml
echo "Bringing up VVM Node '$NAME'"
docker-compose -f "$DIR/$CONFIG" -p "$NAME" up -d

if IP=$(docker-machine ip $(docker-machine active) 2>&1 ) ; then
  echo "using docker-machine..."
else
  echo "using docker-compose only..."
  IP=localhost
fi

echo "Vivitics VirtualMachine Node $NAME running at $IP. Now obtaining token..."

# obtain the live token generated on start up and pull into evar
ACTIVE_TOKEN=$(bash $DIR/open.sh)

if [ -z "$ACTIVE_TOKEN" ]; then
  echo "Failed to obtain ACTIVE_TOKEN, likely failure on notebook startup" 2>&1
  echo "$(date): up.sh failed" >&2
fi

echo success! open http://$IP/nb?token=$ACTIVE_TOKEN
