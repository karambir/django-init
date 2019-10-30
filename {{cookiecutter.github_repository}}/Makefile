.DEFAULT_GOAL := help

.PHONY: clean clean-static clean-build clean-pyc clean-full \
	help setup resetup production-requirements requirements docs html-coverage \
	quality test validate isort black format migrate runserver \
	static{%- if cookiecutter.add_celery.lower() == "y" %} celery{%- endif %}{% if cookiecutter.add_ansible.lower() == 'y' %} full-dev-server full-prod-server deploy-dev-server deploy-prod-server{%- endif %}

# Generates a help message. Borrowed from https://github.com/pydanny/cookiecutter-djangopackage.
help: ## Display this help message
	@echo "Please use \`make <target>\` where <target> is one of"
	@grep '^[a-zA-Z]' $(MAKEFILE_LIST) | sort | awk -F ':.*?## ' 'NF==2 {printf "\033[36m  %-25s\033[0m %s\n", $$1, $$2}'

setup: ## Install pip(through poetry) dependencies
	pyenv install --skip-existing
	poetry install {% if cookiecutter.add_ansible.lower() == 'y' %}--extras "ansible"{%- endif %}
	npm install

resetup: clean-full setup ## Destroy venv and setup again

clean-build: ## Remove build artifacts
	rm -fr build/
	rm -fr dist/
	rm -fr *.egg-info

clean-pyc: ## Remove Python file artifacts
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +

clean-static: ## Remove generated static files
	rm -rf .staticfiles/*

clean: clean-build clean-static clean-pyc ## Remove build, python cache and statifiles artifacts

clean-full: clean ## Remove pyc, static files and venv
	rm -rf .venv venv
	rm -rf node_modules

requirements: ## Install Python and npm requirements for local development
	poetry install {% if cookiecutter.add_ansible.lower() == 'y' %}--extras "ansible"{%- endif %}
	npm install

production-requirements: ## Install Python requirements for production
	poetry install --no-dev

quality: ## Run isort and flake8
	poetry run isort --check-only --recursive --skip migrations {{ cookiecutter.main_module }} settings tests
	poetry run black --check {{ cookiecutter.main_module }} settings tests
	poetry run flake8 {{ cookiecutter.main_module }} settings tests
	{% if cookiecutter.add_ansible.lower() == 'y' %}poetry run ansible-playbook -i provisioner/hosts provisioner/site.yml --syntax-check{%- endif %}

test: ## Run tests and generate coverage report
	poetry run python manage.py check
	poetry run pytest {{ cookiecutter.main_module }} tests

validate: quality test ## Run tests and quality checks

isort: ## Run isort recursively
	poetry run isort --recursive --skip migrations {{ cookiecutter.main_module }} settings tests

black: ## Apply black formatting to python files
	poetry run black {{ cookiecutter.main_module }} settings tests

format: isort black ## Apply isort and black formatting to python files

migrate: ## Apply database migrations
	poetry run python manage.py migrate --noinput

{%- if cookiecutter.add_celery.lower() == "y" %}
celery: ## Run Celery worker
	poetry run celery worker -A {{ cookiecutter.main_module }} -l debug
{%- endif %}

runserver: ## Run Django server
	poetry run python manage.py runserver

static: ## Gather all static assets for production
	poetry run python manage.py collectstatic -v 0 --noinput
	poetry run python manage.py compress -v3 --force

html-coverage: ## Generate and view HTML coverage report
	poetry run coverage html && open htmlcov/index.html

docs:
	poetry run mkdocs serve

{% if cookiecutter.add_ansible.lower() == 'y' %}
full-dev-server: ## Bootstrap and deploy to dev server
	poetry run ansible-playbook -i provisioner/hosts provisioner/site.yml --limit=dev

full-prod-server: ## Bootstrap and deploy to prod server
	poetry run ansible-playbook -i provisioner/hosts provisioner/site.yml --limit=prod

deploy-dev-server: ## Deploy to dev server
	poetry run ansible-playbook -i provisioner/hosts provisioner/site.yml --limit=dev --tags=deploy

deploy-prod-server: ## Deploy to prod server
	poetry run ansible-playbook -i provisioner/hosts provisioner/site.yml --limit=prod --tags=deploy
{%- endif %}