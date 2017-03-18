#!/bin/bash
# Copyright (c) @thomaswilley, 2017
# Some portions:
#   Copyright (c) Jupyter Development Team.
#   Distributed under the terms of the Modified BSD License.

# Set default values for environment variables required by vvm_node.yml

: "${CONFIG:=vvm_node.yml}"
export VVM_CONFIG

: "${NAME:=vvm-notebook}"
export VVM_NAME

# Jupyter docker-stacks build image
: "${VVM_JUPYTERDSIMAGE:=datascience-notebook}"
export VVM_JUPYTERDSIMAGE

# Default port
: "${VVM_PORT:=8001}"
export VVM_PORT

# Container work volume name
: "${VVM_WORK_VOLUME:=$NAME-work}"
export VVM_WORK_VOLUME
: "${VVM_WORK_HOME_PATH:=/home/$VVM_USER/work}"
export VVM_WORK_HOME_PATH

# Container secrets volume name
: "${VVM_SECRETS_VOLUME:=$NAME-secrets}"
export VVM_SECRETS_VOLUME

# public volume (served by nginx)
: "${VVM_PUBLIC_VOLUME:=$NAME-public}"
export VVM_PUBLIC_VOLUME
: "${VVM_PUBLIC_HOME_PATH:=/home/$VVM_USER/public}"
export VVM_PUBLIC_HOME_PATH

# Path to Vivitics magic directory
: "${VVM_VIVITICS_HOME_PATH:=/home/$VVM_USER/work/_Vivitics}"
export VVM_VIVITICS_HOME_PATH

# Dropbox volume
: "${VVM_DROPBOX_VOLUME:=$NAME-dropbox}"
export VVM_DROPBOX_VOLUME
: "${VVM_DROPBOX_HOME_PATH:=/home/$VVM_USER/dropbox}"
export VVM_DROPBOX_HOME_PATH
