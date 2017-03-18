#!/bin/bash
# Copyright (c) @thomaswilley, 2017

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

BASENB_DOCKERFILE_FOLDER=$DIR/vvm_notebook/docker-stacks/base-notebook/
BASENB_DOCKERFILE_PATH=$DIR/vvm_notebook/docker-stacks/base-notebook/Dockerfile

USAGE="Usage: `basename $0` [\$VVM_USER]"

if [ -z $VVM_USER ]; then
  echo $USAGE
  echo "Generates vvm_notebook definition (vvm_note.yml: vvm_notebook -- stores in vvm_node/vvm_notebook/)"
  echo "Fetch and install all the pre-reqs to support building adn launching Vivitics Virtual Machines"
  echo "Environment Variables:"
  echo " > VVM_USER == name of the user account to use for vvm services including jupyter"
  exit 1
fi

# export to evars
export VVM_USER

# create (based on evars)
rm -rf $DIR/vvm_notebook/docker-stacks
mkdir -p $DIR/vvm_notebook/docker-stacks
git clone https://github.com/jupyter/docker-stacks.git $DIR/vvm_notebook/docker-stacks

# copy in the latest custom.js & css for vvm jupyter
cp $DIR/vvm_notebook/custom.js $BASENB_DOCKERFILE_FOLDER
cp $DIR/vvm_notebook/custom.css $BASENB_DOCKERFILE_FOLDER

# edit base jupyter notebook settings to set base url and allow embedding in frames
cat <(cat <<-EOF

c.NotebookApp.base_url = "/nb"
c.NotebookApp.tornado_settings = {
    'headers': {
        'Content-Security-Policy': "frame-ancestors * 'self' "
    }
}

EOF
) >> $BASENB_DOCKERFILE_FOLDER/jupyter_notebook_config.py

# modify base-notebook to use VVM_USER as its NB_USER and copy over custom.js and custom.css
find $DIR/vvm_notebook -name "Dockerfile" -exec sed -i '' "s/jovyan/${VVM_USER}/g" {} ';' # note the -i '' "..." is specific to OSx sed cmd
_LINENO=$(grep -n 'COPY jupyter_notebook_config.py /home/$NB_USER/.jupyter/' $BASENB_DOCKERFILE_PATH | cut -f1 -d:)
awk -v n=$_LINENO -v s="RUN mkdir -p /home/\$NB_USER/.jupyter/custom/" 'NR == n {print s} {print}' $BASENB_DOCKERFILE_PATH > $BASENB_DOCKERFILE_PATH.new
awk -v n=$((_LINENO+1)) -v s="COPY custom.js /home/\$NB_USER/.jupyter/custom/" 'NR == n {print s} {print}' $BASENB_DOCKERFILE_PATH.new > $BASENB_DOCKERFILE_PATH.new2
awk -v n=$((_LINENO+2)) -v s="COPY custom.css /home/\$NB_USER/.jupyter/custom/" 'NR == n {print s} {print}' $BASENB_DOCKERFILE_PATH.new2 > $BASENB_DOCKERFILE_PATH.new3
rm $BASENB_DOCKERFILE_PATH.new
rm $BASENB_DOCKERFILE_PATH.new2
mv $BASENB_DOCKERFILE_PATH.new3 $BASENB_DOCKERFILE_PATH

# if on windows, be sure to run w/in cygwin and uncomment the following to ensure scripts use unix line endings
# find $DIR/ -name "*.sh" -exec dos2unix {} ';'
