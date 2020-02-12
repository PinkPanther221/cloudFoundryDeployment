#!/usr/bin/env bash

cf_admin_password="$(bosh int ~/cf-deployment-vars.yml --path /cf_admin_password)"

cf login -a https://api.20.189.112.57.xip.io -u admin -p "${cf_admin_password}" --skip-ssl-validation
