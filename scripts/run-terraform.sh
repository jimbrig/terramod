#!/usr/bin/env bash

terraform init
terraform plan -out outputs/plans/plan.tfplan
terraform validate
terraform fmt *