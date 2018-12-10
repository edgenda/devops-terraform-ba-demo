#!/bin/bash

terraform init -input=false
terraform plan -out=tfplan -input=false
terraform apply -input=false tfplan
ansible-playbook -i terraform.py playbook.yml
