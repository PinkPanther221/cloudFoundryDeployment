#!/usr/bin/env bash

bosh int ~/bosh-deployment-vars.yml --path /jumpbox_ssh/private_key > jumpbox.key
chmod 600 jumpbox.key
ssh jumpbox@10.0.0.4 -i jumpbox.key
