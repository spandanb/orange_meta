#!/bin/bash

#Sets up the Vino env.
TOPDIR=~/orange

#Check if top dir exists
if [ -d "$TOPDIR" ]; then
    echo "$TOPDIR exists"
    exit
fi

sudo apt-get install pip git -y

sudo pip install virtualenv

#create a virtual env
ENVNAME=vinoenv
virtualenv --system-site-packages $ENVNAME

source $ENVNAME/bin/activate

pip install setuptools
pip install boto3
pip install ansible

mkdir $TOPDIR
cd $TOPDIR

#Get git repos
git clone https://github.com/spandanb/orange_multi multi

git clone https://github.com/spandanb/orange_vino.git vino

git clone https://github.com/spandanb/orange_ansible_wrapper.git ansible_wrapper

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
