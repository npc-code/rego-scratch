package policy_codes

aws_sg_policy_codes := {
    "sg_group_deny": {
        "desc": "this security group contains a permissive ingress rule", 
        "policy_code": "rearc_01"
    }, 
    "sg_rule_deny": {
        "desc": "this security group rule contains ingress from all locations on an unapproved port", 
        "policy_code": "rearc_02"
    }
}