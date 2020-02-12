#!/usr/bin/env bash

export BOSH_ENVIRONMENT=10.0.0.4
export BOSH_CLIENT=admin
export BOSH_CLIENT_SECRET="$(bosh int ~/bosh-deployment-vars.yml --path /admin_password)"
export BOSH_CA_CERT="$(bosh int ~/bosh-deployment-vars.yml --path /director_ssl/ca)"

bosh alias-env azure
bosh -e azure login

bosh -n update-cloud-config ~/example_manifests/cloud-config.yml \
  -v internal_cidr=10.0.16.0/20 \
  -v internal_gw=10.0.16.1 \
  -v vnet_name=boshvnet-crp \
  -v subnet_name=CloudFoundry \
  -v security_group=nsg-cf \
  -v load_balancer_name=cf-lb
bosh -n update-runtime-config ~/example_manifests/dns.yml \
  --name=dns
bosh upload-stemcell --sha1=1417d0a7bdbfc2b4794a4c8799231f0eeec73325 https://bosh.io/d/stemcells/bosh-azure-hyperv-ubuntu-xenial-go_agent?v=170.3

bosh -n -d cf deploy ~/example_manifests/cf-deployment.yml \
  --vars-store=~/cf-deployment-vars.yml \
  -o ~/example_manifests/azure.yml \
  -o ~/example_manifests/scale-to-one-az.yml \
  -o ~/example_manifests/use-compiled-releases.yml \
  -o ~/example_manifests/use-external-blobstore.yml \
  -v app_package_directory_key=cc-packages \
  -v buildpack_directory_key=cc-buildpacks \
  -v droplet_directory_key=cc-droplets \
  -v resource_directory_key=cc-resources \
  -o ~/example_manifests/use-azure-storage-blobstore.yml \
  -v environment=AzureCloud \
  -v blobstore_storage_account_name=gccg5txzs5zgecfdefaultsa \
  -v blobstore_storage_access_key=C2iCCeXzHo+yv+v1ZDJNmAXcAonX0eIbwp+uRZ+kEuIbugHBJIaH8RBcz3GOhHoyo1+hsISq1VPdK+S+xmqRmg== \
  -v system_domain=20.189.112.57.xip.io
