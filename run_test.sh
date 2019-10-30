#!/bin/bash

# Setup for returning a non-zero exit code if any of the command fails.
err=0
trap 'err=1' ERR

rm -rf hello-world-web/;

# Generate new code
cookiecutter . --no-input

# Run the tests present inside generate project
cd hello-world-web;
npm install
npm run build

# Cleanup
test ! $CI && dropdb hello_world

test $err = 0 # Return non-zero if any command failed
