#!/bin/bash

#Sets up the Vino env.
TOPDIR=~/orange
CLIENTMACH=true

#Check if top dir exists
if [ -d "$TOPDIR" ]; then
    echo "$TOPDIR exists"
    exit
fi

mkdir $TOPDIR
cd $TOPDIR

if [ "$CLIENTMACH" = false ]; then
sudo apt-get update
sudo apt-get install python-pip python-dev build-essential git -y
sudo pip install virtualenv
fi

#create a virtual env
ENVNAME=vinoenv
virtualenv --system-site-packages $ENVNAME

source $ENVNAME/bin/activate

#TODO: Put these as dependencies to orange
pip install setuptools
pip install boto3
pip install ansible
pip install requests

#Get git repos
git clone https://github.com/spandanb/orange_multi multi

git clone https://github.com/spandanb/orange_vino.git vino

git clone https://github.com/spandanb/orange_ansible_wrapper.git ansible_wrapper

git clone https://github.com/spandanb/sla_orc.git docker

#create aux files
touch __init__.py

touch setup.py

cat > setup.py <<EOF
from setuptools import setup, find_packages

setup(
        name="orange",
        version="0.1",
        packages = find_packages()
)
EOF

python setup.py develop
