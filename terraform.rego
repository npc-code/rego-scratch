package terraform.sg

import data.policy_codes as policylib

array_contains(arr, elem) {
  arr[_] = elem 
}

public_rule(arr, elem, from_port, to_port) {
  arr[_] = elem
  from_port != 443
  to_port != 443
}


#in line policy code and description
sg_group_deny[reason] {
  resource := input.resource_changes[_]
  cidr_blocks := resource.change.after.ingress[_].cidr_blocks[_]
  array_contains(["0.0.0.0/0"], cidr_blocks)
  result := {
    "resource": resource.address, 
    "description": "this security group contains a permissive ingress rule", 
    "policy_code": "Rearc_aws_sg_group_ingress_01"
  } 
  reason := result
}

sg_rule_deny[reason] {
  resource := input.resource_changes[_]
  cidr_blocks := resource.change.after.cidr_blocks[_]
  from_port := resource.change.after.from_port
  to_port := resource.change.after.to_port
  public_rule(["0.0.0.0/0"], cidr_blocks, from_port, to_port)
  reason := {
    "resource": resource.address, 
    "description": "bad rule", 
    "policy_code": "rearc_aws_sg_rule_01"
  }
}

sg_rule_deny_imported[reason] {
  resource := input.resource_changes[_]
  cidr_blocks := resource.change.after.cidr_blocks[_]
  from_port := resource.change.after.from_port
  to_port := resource.change.after.to_port
  public_rule(["0.0.0.0/0"], cidr_blocks, from_port, to_port)
  offending_resource := resource.address
  description := policylib.aws_sg_policy_codes.sg_rule_deny["desc"]
  policy_code := policylib.aws_sg_policy_codes.sg_rule_deny["policy_code"]
  reason := {
    "resource": offending_resource, 
    "description": description, 
    "policy_code": policy_code
  }
}

#security_groups = all {
#  all := [ name |
#    name := input.resource_changes[_]
#    name.type == "aws_security_group"
#  ]
#}

#allowed_groups {
#  names := security_groups[_].name
#}


#resources[resource_type] = all {
#    some resource_type
#    resource_types[resource_type]
#    all := [name |
#        name:= input.resource_changes[_]
#        name.type == resource_type
#    ]
#}