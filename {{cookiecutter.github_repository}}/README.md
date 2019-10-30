{{ cookiecutter.project_name }}
==============================

__Version:__ {{ cookiecutter.version }}

{{ cookiecutter.project_description }}

## Getting up and running

Minimum requirements: **Make, [pyenv](https://github.com/pyenv/pyenv), [poetry](https://poetry.eustace.io),{% if cookiecutter.webpack == 'y' %}, [nvm](https://github.com/nvm-sh/nvm), npm{% endif %}, redis & [PostgreSQL 11][install-postgres]{% if cookiecutter.postgis == 'y' %} with postgis-2.4{% endif %}**, setup is tested on Mac OSX only.

```
brew install postgres
curl https://pyenv.run | bash
curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python3
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.0/install.sh | bash
```

Make sure to add PATHs from above tools to your bash/zsh PATH and restart your shell.

[install-postgres]: http://www.gotealeaf.com/blog/how-to-install-postgresql-on-a-mac

In your terminal, type or copy-paste the following:

    git clone git@github.com:{{ cookiecutter.github_username }}/{{ cookiecutter.github_repository }}.git; cd {{ cookiecutter.github_repository }}; make setup

Go grab a cup of coffee, we bake your hot development machine.

Useful commands:

- `make runserver` - start [django server](http://localhost:8000/)
- `make format` - Run isort and black
- `make validate` - check isort and flake8 and pytest
- `make deploy-dev-server` - deploy to dev server
- `make deploy-prod-server` - deploy to dev server

**NOTE:** Run `make help` for all the options available.


## Deploying Project

The deployment are managed via travis, but for the first time you'll need to set the configuration values on each of the server.

Check out detailed server setup instruction [here](docs/backend/server_config.md).

## How to release {{ cookiecutter.project_name }}

Execute the following commands:

```
git checkout master
make validate
bumpversion patch  # 'patch' can be replaced with 'minor' or 'major'
git push origin master
git push origin master --tags
git checkout qa
git rebase master
git push origin qa
```

## Contributing

Golden Rule:

> Anything in **master** is always **deployable**.

Avoid working on `master` branch, create a new branch with meaningful name, send pull request asap. Be vocal!

Refer to [CONTRIBUTING.md][contributing]

[contributing]: http://github.com/{{cookiecutter.github_username}}/{{cookiecutter.github_repository}}/tree/master/CONTRIBUTING.md
