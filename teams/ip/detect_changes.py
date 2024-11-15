import json
import sys
import os

def load_json(file_path):
    if not os.path.exists(file_path):
        return None
    with open(file_path, "r") as file:
        return json.load(file)

def detect_changes(new_file, old_file):
    new_data = load_json(new_file)
    old_data = load_json(old_file)

    if not new_data or not old_data:
        print("No previous file for comparison.")
        return

    new_rules = {rule["name"]: rule for rule in new_data["rules"]}
    old_rules = {rule["name"]: rule for rule in old_data["rules"]}

    for rule_name in new_rules:
        if rule_name not in old_rules:
            print(f"Rule added: {rule_name}")
        elif new_rules[rule_name] != old_rules[rule_name]:
            print(f"Rule modified: {rule_name}")

    for rule_name in old_rules:
        if rule_name not in new_rules:
            print(f"Rule deleted: {rule_name}")

# Compare both JSON files for changes
if __name__ == "__main__":
    detect_changes("security_rules.json", "archive/security_rules_old.json")
    detect_changes("application.json", "archive/application_old.json")

