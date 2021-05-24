# rego-scratch

currently a scratchpad for working with opa and rego

## usage

### opa demo:

currently can use the sample terraform code for testing.
- create a .auto.tfvars file and set your profile if needed.
- execute: ```./test_gen.sh```.  this will create a json file from the terraform plan command.
- if running docker:
  - execute: ```docker run -it --rm -v $PWD:/example openpolicyagent/opa eval --format pretty -b /example  --input /example/tfplan.json "data.terraform.sg"```
- if using binary:
  - execute: ```opa eval --format pretty -b . --input tfplan.json "data.terraform.sg"```

### string builder 

- execute: ```python3 policy_builder.py```

