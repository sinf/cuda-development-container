#!/bin/sh
python3 -m venv ./venv
. ./venv/bin/activate
pip install --upgrade pip
cd src
if [ -f requirements.lock ]; then
	pip install -r requirements.lock
else
	pip install -r requirements.txt
fi

