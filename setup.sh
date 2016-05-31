#!/bin/bash

#Sets up the Vino env.
TOPDIR=~/orange
#this is the client machine, i.e. does the user have sudo access
CLIENTMACH=true

#Check if top dir exists
if [ -d "$TOPDIR" ]; then
    echo "$TOPDIR exists"
    rm -rf $TOPDIR
fi

mkdir $TOPDIR
cd $TOPDIR

#Get git repos
git clone https://github.com/spandanb/orange_multi multi
git clone https://github.com/spandanb/orange_vino.git vino
git clone https://github.com/spandanb/orange_ansible_wrapper.git ansible_wrapper
git clone https://github.com/spandanb/sla_orc.git docker

#create aux files
touch __init__.py

cat > setup.py <<EOF
from setuptools import setup, find_packages

setup(
        name="orange",
        version="0.1",
        packages = find_packages(),
        install_requires = ['boto3', 'ansible', 'requests']
)
EOF

if [ "$CLIENTMACH" = true ]; then
    #create a virtual env
    ENVNAME=vinoenv
    virtualenv --system-site-packages $ENVNAME
    source $ENVNAME/bin/activate
    python setup.py develop
else
    sudo apt-get update
    sudo apt-get install python-pip python-dev build-essential git -y
    sudo pip install virtualenv
    sudo pip install setuptools
    sudo apt-get install libffi-dev libssl-dev -y
    sudo python setup.py develop
fi



