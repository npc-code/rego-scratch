#!/bin/bash
cd test_data && terraform init
terraform plan --out tfplan.binary
terraform show -json tfplan.binary > tfplan.json
mv tfplan.json ..
