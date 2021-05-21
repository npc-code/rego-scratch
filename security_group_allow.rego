package terraform.sg_allow

#execute: docker run -it --rm -v $PWD:/example openpolicyagent/opa eval --format pretty -b /example  --input /example/tfplan.json "data.terraform.sg_allow.deny"
allowed_names := {"good_sg"}

security_groups := { name |
	name := input.resource_changes[_]
    name.type == "aws_security_group"
}

security_group_names = all {
   all := { name |
      name := security_groups[_].name
   }
}

names_not_in_allowed_names := security_group_names - allowed_names

deny [reason] {
    count(names_not_in_allowed_names) > 0
    result := {
        "description" : "security groups not in approved list",
        "security_group_names" : names_not_in_allowed_names  
    } 
    reason := result
}