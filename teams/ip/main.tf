terraform {
  required_providers {
    panos = {
      source  = "PaloAltoNetworks/panos"
      version = "1.9.0"
    }
  }
}

# Provider Configuration for Palo Alto
provider "panos" {
  hostname = var.palo_alto_hostname
  username = var.palo_alto_username
  password = var.palo_alto_password
}

# Variables for Palo Alto Lab Credentials
variable "palo_alto_hostname" {}
variable "palo_alto_username" {}
variable "palo_alto_password" {}

# JSON Files for Application and Security Rules
variable "security_rules_path" {
  default = "security_rules.json"
}

variable "application_rules_path" {
  default = "application.json"
}

# Read Security Rules from JSON
data "template_file" "security_rules" {
  template = file(var.security_rules_path)
}

# Read Application Rules from JSON
data "template_file" "application_rules" {
  template = file(var.application_rules_path)
}

# Parse JSON Data and Create Firewall Rules
resource "panos_security_rule" "security_rules" {
  count       = length(jsondecode(data.template_file.security_rules.rendered))
  rule_name   = jsondecode(data.template_file.security_rules.rendered)[count.index]["rule_name"]
  source_zone = jsondecode(data.template_file.security_rules.rendered)[count.index]["source_zone"]
  destination_zone = jsondecode(data.template_file.security_rules.rendered)[count.index]["destination_zone"]
  source_address = jsondecode(data.template_file.security_rules.rendered)[count.index]["source_address"]
  destination_address = jsondecode(data.template_file.security_rules.rendered)[count.index]["destination_address"]
  application = jsondecode(data.template_file.security_rules.rendered)[count.index]["application"]
  action      = jsondecode(data.template_file.security_rules.rendered)[count.index]["action"]
  description = jsondecode(data.template_file.security_rules.rendered)[count.index]["description"]
  tag         = jsondecode(data.template_file.security_rules.rendered)[count.index]["tag"]
}

resource "panos_security_rule" "application_rules" {
  count       = length(jsondecode(data.template_file.application_rules.rendered))
  rule_name   = jsondecode(data.template_file.application_rules.rendered)[count.index]["rule_name"]
  source_zone = jsondecode(data.template_file.application_rules.rendered)[count.index]["source_zone"]
  destination_zone = jsondecode(data.template_file.application_rules.rendered)[count.index]["destination_zone"]
  source_address = jsondecode(data.template_file.application_rules.rendered)[count.index]["source_address"]
  destination_address = jsondecode(data.template_file.application_rules.rendered)[count.index]["destination_address"]
  application = jsondecode(data.template_file.application_rules.rendered)[count.index]["application"]
  action      = jsondecode(data.template_file.application_rules.rendered)[count.index]["action"]
  description = jsondecode(data.template_file.application_rules.rendered)[count.index]["description"]
  tag         = jsondecode(data.template_file.application_rules.rendered)[count.index]["tag"]
}

# Outputs for Applied Rules
output "security_rules_applied" {
  value = panos_security_rule.security_rules[*].rule_name
}

output "application_rules_applied" {
  value = panos_security_rule.application_rules[*].rule_name
}

