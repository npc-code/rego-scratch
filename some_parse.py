import json

def main():
    with open("./results.json") as data_file:
        data = json.loads(data_file.read())

    for violation in data["sg_group_deny_clone"]:
        print(f"resource: {violation['resource']}")
        print(f"reason: {violation['description']}")
        print(f"Policy Code: {violation['policy_code']}")
        print("\n")

if __name__ == "__main__":
    main()