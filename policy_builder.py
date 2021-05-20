import yaml

def policy_builder(yaml_file):
  with open(yaml_file, 'r') as stream:
    try:
      yaml_data = yaml.safe_load(stream)
    except yaml.YAMLError as exc:
      print(exc)

    print(yaml_data)
    rule_name = yaml_data["policy"]["name"]
    test_resource = "cidr_blocks"
    function_name = "array_contains"
    description = "this security group contains a permissive ingress rule"
    policy_code = "rearc_01"
    #
    #TODO
    #logic for parsing parent/child resources
    rego_rule = f"""    {rule_name}[reason] {{
        \tresource := input.resource_changes[_]
        \t{test_resource} := resource.change.after.ingress[_].{test_resource}[_]
        \t{function_name}(["0.0.0.0/0"], {test_resource})
        \tresult := {{
        \t\t"resource": resource.address,
        \t\t"description": {description},
        \t\t"policy_code": {policy_code}
        \t}}
        \treason := result
    }}
    """



    return rego_rule


def tests():
  print(policy_builder("sg_group_deny.yaml"))

tests()