#!/bin/bash
# Copyright (c) @thomaswilley, 2017

# This script polls vvm_notebook looking for a jupyter token
# and either times out after 5 attempts or returns the token to stdout

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Setup environment
source "$DIR/env.sh"

# obtain the live token generated on start up and pull into evar
n=0
until [ $n -ge 5 ]
do
  _ATTEMPTED_TOKEN=$(docker exec vvm_notebook jupyter notebook list | awk -F'[=&]' '{print $2}' | awk '{print $1}' | sed '/^$/d')
  if [ -z "$_ATTEMPTED_TOKEN" ]; then
    echo "polling for token... attempt $n / 5" >&2 # to stderr
  else
    ACTIVE_TOKEN=$_ATTEMPTED_TOKEN # result of above command
    break
  fi
  n=$[$n+1]
  sleep 1
done

if [ -z "$ACTIVE_TOKEN" ]; then
  echo "Unable to confirm notebook is alive & obtain token. Max tries exceeded." >&2
else
  echo "${ACTIVE_TOKEN}"
fi
