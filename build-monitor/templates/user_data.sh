#!/bin/bash
cd /tmp
aws s3 cp s3://prm-327778747031-buildmonitor-build-files/ansible-template.zip .
unzip ansible-template.zip
sudo yum update -y
sudo amazon-linux-extras install epel -y
sudo yum install ansible -y
aws configure set default.region eu-west-2
ansible-playbook ansible-playbook-aws-install-docker.yml