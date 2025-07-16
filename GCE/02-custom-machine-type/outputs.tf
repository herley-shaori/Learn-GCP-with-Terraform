# Output values for the custom machine type demo

# Instance information
output "instance_name" {
  description = "Name of the created instance"
  value       = google_compute_instance.custom_machine.name
}

output "instance_id" {
  description = "ID of the created instance"
  value       = google_compute_instance.custom_machine.id
}

output "instance_self_link" {
  description = "Self link of the instance"
  value       = google_compute_instance.custom_machine.self_link
}

# Network information
output "external_ip" {
  description = "External IP address of the instance"
  value       = google_compute_address.static_ip.address
}

output "internal_ip" {
  description = "Internal IP address of the instance"
  value       = google_compute_instance.custom_machine.network_interface[0].network_ip
}

# Machine type information
output "machine_type" {
  description = "Machine type of the instance"
  value       = local.selected_config.machine_type
}

output "machine_specs" {
  description = "Specifications of the selected machine type"
  value = {
    type        = var.selected_machine_type
    vcpus       = local.selected_config.vcpus
    memory_mb   = local.selected_config.memory_mb
    description = local.selected_config.description
  }
}

# Connection information
output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "gcloud compute ssh ${google_compute_instance.custom_machine.name} --zone=${var.zone}"
}

output "http_url" {
  description = "HTTP URL to test the web server"
  value       = "http://${google_compute_address.static_ip.address}"
}

output "ping_command" {
  description = "Command to ping the instance"
  value       = "ping ${google_compute_address.static_ip.address}"
}

# Cost optimization information
output "cost_optimization" {
  description = "Cost optimization features applied"
  value = {
    preemptible    = "Yes - Using spot/preemptible instance"
    disk_type      = var.boot_disk_type
    disk_size_gb   = var.boot_disk_size
    machine_type   = "Custom machine type for optimal resource allocation"
  }
}

# All available machine configurations
output "available_machine_types" {
  description = "All available machine type configurations"
  value       = var.machine_configs
}