#!/bin/bash
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

# Ensure newline at EOF
find . ! -path "*/venv/*" -type f -name "*.py" -exec bash -c "tail -n1 {} | read -r _ || echo >> {}" \;

echo "${green}[Finished]${reset}"

if echo "{{ cookiecutter.add_ansible }}" | grep -iq "^n"; then
    rm -rf provisioner Vagrantfile ansible.cfg
fi

if echo "{{ cookiecutter.webpack }}" | grep -iq "^n"; then
    rm -f package.json package-lock.json
    rm -f {{cookiecutter.main_module}}/static/server.js
    rm -f {{cookiecutter.main_module}}/static/webpack.config.js
    rm -f webpack-stats.json
fi

if echo "{{ cookiecutter.add_celery }}" | grep -iq "^n"; then
    rm -rf {{ cookiecutter.main_module }}/celery.py
fi

if echo "{{ cookiecutter.add_pre_commit }}" | grep -iq "^n"; then
    rm .pre-commit-config.yaml
fi