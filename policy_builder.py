import yaml

def policy_builder(yaml_file):
  '''
  returns a formatted string that can be used as a rego policy

            Parameters:
                    yaml_file (path to .yaml file) 

            Returns:
                    rego_rule (str): rego rule created from entries in the yaml file
  
  '''
  with open(yaml_file, 'r') as stream:
    try:
      yaml_data = yaml.safe_load(stream)
    except yaml.YAMLError as exc:
      print(exc)

    rule_name = yaml_data["policy"]["name"]
    test_resource_address = resource_address_builder(yaml_data["policy"]["config"]["path_to_resource"])
    test_resource = yaml_data["policy"]["config"]["path_to_resource"][-1]["name"]
    function_name = "array_contains"
    description = yaml_data["policy"]["config"]["description"]
    policy_code = yaml_data["policy"]["config"]["policy_code"]
    doc_link = yaml_data["policy"]["config"]["doc_link"]
    #
    #TODO
    #logic for parsing parent/child resources
    rego_rule = f"""    {rule_name}[reason] {{
        \tresource := input.resource_changes[_]
        \t{test_resource} := resource.change.after.{test_resource_address}
        \t{function_name}(["0.0.0.0/0"], {test_resource})
        \tresult := {{
        \t\t"resource": resource.address,
        \t\t"description": {description},
        \t\t"policy_code": {policy_code}
        \t\t"document_link": {doc_link}
        \t}}
        \treason := result
    }}
    """
    return rego_rule

def resource_address_builder(addresses):
  '''
  returns a path to the resource to be tested within the terraform plan in json format

        Parameters:
          addresses (list) : structure is based off of the yaml file being passed, this will need to be formalized
        Returns:
          address (str) : string in the format of item1.item2....itemN.  If the item to be tested is an array, the item name 
          has [_] appended to it.  "_" is the convention within rego to look at any item within an array.
          an example would be:  item1[_].item2[_].item3 

  '''

  address = ""
  
  for item in addresses:
    address += item["name"]
    if item["array"]:
      address += "[_]"
    if addresses[-1] != item:
      address += "."  
  return address

def tests():
  print(policy_builder("sg_group_deny.yaml"))

tests()