#!/bin/bash

sudo apt-get install python-pip
python -m pip install --upgrade pip

sudo apt-get install python-dev python3-dev libpq-dev postgresql-client-common postgresql-client mysql-client\
     libmysqlclient-dev libxml2-dev libxslt1-dev python-cffi-backend python-paramiko libffi-dev python-psycopg2

python -m pip install --upgrade virtualenv virtualenvwrapper awscli

sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt-get update
sudo apt-get install python3.6
