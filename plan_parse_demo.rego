package terraform.plan_parse_demo

import data.tf_plan_parse as tf_plan_parse
#execute: docker run -it --rm -v $PWD:/example openpolicyagent/opa eval --format pretty -b /example  --input /example/tfplan.json "data.terraform.plan_parse_demo"

#gets a list of all security group names
security_group_names = all {
   all := { name |
      name := tf_plan_parse.security_groups[_].name
   }
}

security_rule_names = all {
    all := { name |
      name := tf_plan_parse.security_group_rules[_].name
    }
}

vpc_names = all {
  all := { name |
    name := tf_plan_parse.vpcs[_].name
  }
}

# creates a mapping of security group name to address within the terraform project
security_group_data = { group.name : group.address |
  group := tf_plan_parse.security_groups[_]

}
