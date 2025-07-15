# This file defines output values that will be displayed after Terraform applies
# Outputs are useful for:
# 1. Displaying important information after deployment
# 2. Passing data between Terraform modules
# 3. Integration with other tools and scripts

# Basic Instance Information
# --------------------------

# The instance name is useful for identifying the VM in GCP Console
# This outputs the actual name assigned to the instance
output "instance_name" {
  description = "The name of the GCE instance"
  # Reference format: resource_type.resource_name.attribute
  value       = google_compute_instance.basic_vm.name
}

# Zone information confirms where the instance was deployed
# Important for understanding latency and data residency
output "instance_zone" {
  description = "The zone where the instance is deployed"
  value       = google_compute_instance.basic_vm.zone
}

# Network Information
# -------------------

# External IP is needed to connect to the instance from the internet
# This IP is ephemeral and will change if the instance is stopped/started
# Note: [0] accesses the first (and only) network interface
output "instance_external_ip" {
  description = "The external IP address of the instance"
  # network_interface is a list, even with one interface
  # access_config is also a list, allowing multiple external IPs
  value       = google_compute_instance.basic_vm.network_interface[0].access_config[0].nat_ip
}

# Internal IP is used for communication within the VPC
# This IP is stable and doesn't change
output "instance_internal_ip" {
  description = "The internal IP address of the instance"
  # network_ip is directly available on the network interface
  value       = google_compute_instance.basic_vm.network_interface[0].network_ip
}

# Instance Identifiers
# --------------------

# Instance ID is a unique numeric identifier
# Useful for API calls and automation scripts
output "instance_id" {
  description = "The instance ID"
  value       = google_compute_instance.basic_vm.instance_id
}

# Self link is the full resource URL in GCP
# Can be used to reference this instance in other resources
# Format: https://www.googleapis.com/compute/v1/projects/{project}/zones/{zone}/instances/{name}
output "instance_self_link" {
  description = "The self link of the instance"
  value       = google_compute_instance.basic_vm.self_link
}

# Convenience Outputs
# -------------------

# Constructed URL for easy web access
# This combines the protocol with the external IP
# Users can click this link to test the web server
output "web_url" {
  description = "URL to access the web server"
  # String interpolation using ${} syntax
  # Constructs: http://<external_ip>
  value       = "http://${google_compute_instance.basic_vm.network_interface[0].access_config[0].nat_ip}"
}

# Additional Notes on Outputs:
# ----------------------------
# 1. Outputs are shown after 'terraform apply' completes
# 2. View outputs anytime with: terraform output
# 3. Get specific output: terraform output instance_external_ip
# 4. Get output as JSON: terraform output -json
# 5. Sensitive outputs can be marked with: sensitive = true
#    This prevents them from being displayed in logs
#
# Example of sensitive output:
# output "admin_password" {
#   description = "Admin password for the instance"
#   value       = random_password.admin.result
#   sensitive   = true
# }
#
# 6. Outputs can have complex types:
#    - string (default)
#    - number
#    - bool
#    - list
#    - map
#    - object
#    - tuple
#
# 7. In modules, outputs are the way to return values
#    Parent module accesses them as: module.module_name.output_name