#!/usr/bin/env bash

set -e

export BOSH_LOG_LEVEL="debug"
export BOSH_LOG_PATH="./run.log"

bosh create-env ~/example_manifests/bosh.yml \
  --state=state.json \
  --vars-store=~/bosh-deployment-vars.yml \
  -o ~/example_manifests/cpi.yml \
  -o ~/example_manifests/use-location.yml \
  -o ~/example_manifests/custom-cpi-release.yml \
  -o ~/example_manifests/custom-environment.yml \
  -o ~/example_manifests/use-azure-dns.yml \
  -o ~/example_manifests/jumpbox-user.yml \
  -o ~/example_manifests/keep-failed-or-unreachable-vms.yml \
  -o ~/example_manifests/uaa.yml \
  -o ~/example_manifests/credhub.yml \
  -v director_name=azure \
  -v internal_cidr=10.0.0.0/24 \
  -v internal_gw=10.0.0.1 \
  -v internal_ip=10.0.0.4 \
  -v cpi_release_url=https://bosh.io/d/github.com/cloudfoundry/bosh-azure-cpi-release?v=35.5.0 \
  -v cpi_release_sha1=faebe370c143554fe471c3f6aafb523ab48c43ea \
  -v director_vm_instance_type=Standard_D2_v2 \
  -v resource_group_name=bosh-1 \
  -v location=eastasia \
  -v vnet_name=boshvnet-crp \
  -v subnet_name=Bosh \
  -v default_security_group=nsg-bosh \
  -v environment=AzureCloud \
  -v subscription_id=c9c6e5d3-e2bc-48da-a42b-d5a95c82c3da \
  -v tenant_id=c185456c-5a15-4f27-84bf-071642573f29 \
  -v client_id=7a362c61-392a-404b-a842-013ec2d85d8b \
  -v client_secret="35cb6d77-511f-4bc1-b739-d9d22160e2d4" \
  -o ~/example_manifests/use-managed-disks.yml

cat >> "/home/bosh-1/.profile" << EndOfFile
# BOSH CLI
export BOSH_ENVIRONMENT=10.0.0.4
export BOSH_CLIENT=admin
export BOSH_CLIENT_SECRET="$(bosh int ~/bosh-deployment-vars.yml --path /admin_password)"
export BOSH_CA_CERT="$(bosh int ~/bosh-deployment-vars.yml --path /director_ssl/ca)"
EndOfFile
source /home/bosh-1/.profile
