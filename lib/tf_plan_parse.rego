package tf_plan_parse

import input as tfplan

tf_plan_resources [resources] {
    resources := tfplan.resource_changes[_]
}

security_groups := { name |
    name := tf_plan_resources[_]
    name.type == "aws_security_group"
}

security_group_rules := { name |
    name := tf_plan_resources[_]
    name.type == "aws_security_group_rule"
}

vpcs := { name |
    name := tf_plan_resources[_]
    name.type == "aws_vpc"
}