#!/bin/bash

set -e
sudo cloud-init clean --logs
packer init .
PACKER_LOG=debug PACKER_LOG_PATH=packer-debug.log packer build ubuntuserver.pkr.hcl 

rm packer-debug.log
echo "Packer build complete"

