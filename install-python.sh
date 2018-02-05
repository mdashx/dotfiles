#!/bin/bash

sudo apt-get install python-pip
pip install --upgrade pip

sudo apt-get install python-dev python3-dev libpq-dev postgresql-client-common postgresql-client mysql-client\
     libmysqlclient-dev libxml2-dev libxslt1-dev python-cffi-backend python-paramiko libffi-dev python-psycopg2

pip install --upgrade virtualenv virtualenvwrapper awscli
