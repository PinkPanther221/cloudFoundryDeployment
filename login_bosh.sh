#!/usr/bin/env bash

export BOSH_ENVIRONMENT=10.0.0.4
export BOSH_CLIENT=admin
export BOSH_CLIENT_SECRET="$(bosh int ~/bosh-deployment-vars.yml --path /admin_password)"
export BOSH_CA_CERT="$(bosh int ~/bosh-deployment-vars.yml --path /director_ssl/ca)"

bosh alias-env azure
bosh -e azure login
