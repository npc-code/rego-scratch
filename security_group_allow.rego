package terraform.sg_allow

#execute: docker run -it --rm -v $PWD:/example openpolicyagent/opa eval --format pretty -b /example  --input /example/tfplan.json "data.terraform.sg_allow.deny"
#predefined collection of "good" names.
allowed_names := {"good_sg"}

#gets all security groups from plan json
security_groups := { name |
	  name := input.resource_changes[_]
    name.type == "aws_security_group"
}

# gets a list of all security group names
security_group_names = all {
   all := { name |
      name := security_groups[_].name
   }
}

# creates a mapping of security group name to address within the terraform project
security_group_data = { group.name : group.address |
  group := security_groups[_]

}

#set operation, finds security group names present that are not in the allow list
names_not_in_allowed_names := security_group_names - allowed_names


# checks if there are any offending names.  simply prints out the violation and list of the names that are in violation
deny [reason] {
    count(names_not_in_allowed_names) > 0
    result := {
        "description" : "security groups not in approved list",
        "security_group_names" : names_not_in_allowed_names  
    } 
    reason := result
}

# same check as above.  creates a collection with security group name as the key.
deny [reason] {
    count(names_not_in_allowed_names) > 0
    result = { name: address |
      name := names_not_in_allowed_names[_]
      address := {"resource address": security_group_data[name], "description": "security group not in approved list"}
    } 
    reason := result
}

default test_condition = false

test_condition {                                      # allow is true if...
    count(deny) == 0                           # there are zero violations.
}