#!/bin/bash
# Copyright (c) @thomaswilley, 2017

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

USAGE="Usage: `basename $0` \$DM_NAME [--driver \$MACHINE_DRIVER]"

# defaults (pull from evars or set as defaults
: "${MACHINE_DRIVER:=virtualbox}"
: "${DM_NAME:=$1}"

if [ -z $DM_NAME ]; then
  echo $USAGE
  echo "Build a docker machine from the given driver and environment settings (local virtualbox by default)"
  echo "Environment variables:"
  echo " > DM_NAME == desired name of docker machine (can also be provided as argument)"
  echo " > MACHINE_DRIVER == desired name of docker machine (can also be set by command line flag)"
  echo "Plus any others required for successful docker-machine create..."
  exit 1
fi

# parse options
while [[ $# > 1 ]]
do
  key="$1"
  case $key in
    --driver)
      MACHINE_DRIVER="$2"
      export MACHINE_DRIVER
      ;;
    *) # unknown option
      ;;
  esac
  shift # past argument or value
done

# export to evars
export MACHINE_DRIVER

# create (based on evars)
docker-machine create $DM_NAME
docker-machine env $DM_NAME
