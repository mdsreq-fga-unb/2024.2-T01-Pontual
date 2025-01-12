## Base Makefile ##

# Configuration
config: copy-env setup-env
copy-env:
	cp ./api/.env.example ./api/.env

setup-env:
	bash scripts/env.sh

# Install Dependencies
install:
	pip install -r ./api/requirements.txt

# Start Application
start:
	python3 api/manage.py migrate
	python3 api/manage.py initadmin
	python3 api/manage.py runserver 0.0.0.0:8080
