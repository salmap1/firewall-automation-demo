import json
import re
import sys

def validate_ip(ip):
    # Check if the IP address format is valid
    pattern = re.compile(r"^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$")
    if not pattern.match(ip):
        return False
    return all(0 <= int(octet) <= 255 for octet in ip.split("."))

def validate_rules(file_path):
    try:
        with open(file_path, "r") as file:
            data = json.load(file)
        
        rule_names = set()
        for rule in data["rules"]:
            name = rule.get("name")
            if name in rule_names:
                print(f"Duplicate rule name detected: {name}")
                return False
            rule_names.add(name)

            # Validate IPs in source and destination
            if not validate_ip(rule.get("source", "")) or not validate_ip(rule.get("destination", "")):
                print(f"Invalid IP address in rule: {name}")
                return False

        print(f"Validation passed for {file_path}.")
        return True

    except Exception as e:
        print(f"Error reading {file_path}: {e}")
        return False

# Run validation for both JSON files
if __name__ == "__main__":
    security_valid = validate_rules("security_rules.json")
    application_valid = validate_rules("application.json")
    sys.exit(0 if security_valid and application_valid else 1)

