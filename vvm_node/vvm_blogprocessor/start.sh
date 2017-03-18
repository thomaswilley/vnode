#!/bin/bash
# Copyright (c) Thomas Willey
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

USAGE="Usage: `basename $0` \$ [--run-once, --use-sample-post, --help]"

if [ -z "$NB_USER" || -z "$VVM_HOME" || -z "$VVM_HOME_BLOG" || -z "$VVM_PUBLIC_PATH" ]; then
  echo $USAGE
  echo "Unable to start because mandatory environment variables are missing from environment:"
  printenv
fi

# defaults (pull from evars or set as defaults
#: "${NB_USER:=vivitics}"
#export NB_USER
#: "${VVM_HOME:=/home/$NB_USER/work/_Vivitics}"
#export VVM_HOME
#: "${VVM_HOME_BLOG:=/home/$NB_USER/work/_Vivitics/_Blog}"
#export VVM_HOME_BLOG
# VVM_PUBLIC_PATH should be passed in explicitly
#: "${VVM_PUBLIC_PATH:=/home/$NB_USER/public}"
#export VVM_PUBLIC_PATH

# parse options
# defaults
RUN_FOREVER=yes
SHOW_HELP_AND_EXIT=no
USE_SAMPLE_POST=no
# parse
while [[ $# > 0 ]]
do
  key="$1"
  case $key in
    --run-once)
      RUN_FOREVER=no
      ;;
    --help)
      SHOW_HELP_AND_EXIT=yes
      ;;
    --use-sample-post)
      USE_SAMPLE_POST=yes
      ;;
    *) # unknown option
      ;;
  esac
  shift # past argument or value done
done

# must be run as root (we chown stuff later using NB_USER...
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root"
  exit 1
fi

if [ "$SHOW_HELP_AND_EXIT" == yes ]; then
  echo $USAGE
  echo "Generate new Pelican static blog with Pelicanyan theme and stay in run-loop forever (unless --run-once flag is added)"
  echo "Environment variables:"
  echo " > NB_USER == the user account for jupyter (this script will chown so files are +rw through jupyter)"
  echo " > VVM_HOME == home directory for \$NB_USER"
  echo " > VVM_HOME_BLOG == home directory for the blog (this is the directory which gets watched for changes (e.g., addition of .md/.rst files))"
  echo " > VVM_PUBLIC_PATH == should be explicitly set from docker-compose yml file (b/c typically this is a separate docker volume)"
  echo "Flags:"
  echo " --run-once: pelican will be run exactly once"
  echo " --use-sample-post: will generate a sample post in $VVM_HOME_BLOG before running (ASSUMES file sample-post.md exists in same dir as this script)"
  exit 1
fi

# apparently docker-compose doesnt have a nice way to
# create dirs & manage perms in dockerfiles, need to create
# notebook user as 1000 in each container and chown inside
# start scripts like this...

# create home & blog dirs if not already exist
mkdir -p $VVM_HOME
mkdir -p $VVM_HOME_BLOG

# if we need a sample post, move it to $VVM_HOME_BLOG
if [ "$USE_SAMPLE_POST" == yes ]; then
  # only copy in sample-post.md if $VVM_HOME_BLOG is empty (to avoid conflicts, etc)
  if [ "$(ls -A $VVM_HOME_BLOG)" ]; then
    echo "Cowardly refusing to copy in sample-post because $VVM_HOME_BLOG is not empty"
  else
    cp $DIR/sample-post.md $VVM_HOME_BLOG/
    echo "Copied sample-post.md to $VVM_HOME_BLOG/"
  fi
fi

# confirm pelicanconf.py is in canonical place, else copy starter edition
ls -als $VVM_HOME/pelicanconf.py &>/dev/null || \
  cp $DIR/pelicanconf.py $VVM_HOME/

# confirm theme (pelicanyan) has been installed in canonical place, else install
ls -als $VVM_HOME/pelicanyan &>/dev/null || \
  git clone https://github.com/thomaswilley/pelicanyan.git $VVM_HOME/pelicanyan \
	    && wget -P $VVM_HOME/pelicanyan/static/css https://raw.githubusercontent.com/poole/lanyon/master/public/css/lanyon.css \
	    && wget -P $VVM_HOME/pelicanyan/static/css https://raw.githubusercontent.com/poole/lanyon/master/public/css/poole.css \
	    && wget -P $VVM_HOME/pelicanyan/static/css https://raw.githubusercontent.com/poole/lanyon/master/public/css/syntax.css

# ensure notebook author can edit files
chown -R $NB_USER $VVM_HOME

# generate output
if [[ "$RUN_FOREVER" == no || "$USE_SAMPLE_POST" == yes ]]; then
  pelican -s $VVM_HOME/pelicanconf.py -t $VVM_HOME/pelicanyan/ $VVM_HOME_BLOG/ -o $VVM_PUBLIC_PATH
  echo blogprocessor ran once for $VVM_HOME_BLOG.
fi
if [ "$RUN_FOREVER" == yes ]; then
  watchmedo shell-command $VVM_HOME_BLOG --command 'pelican -s $VVM_HOME/pelicanconf.py -t $VVM_HOME/pelicanyan/ $VVM_HOME_BLOG/ -o $VVM_PUBLIC_PATH'
  echo blogprocessor now watching $VVM_HOME_BLOG for changes...
fi
