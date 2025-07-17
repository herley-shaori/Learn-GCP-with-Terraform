# Output values for the startup script demo

# Instance information
output "instance_name" {
  description = "Name of the created instance"
  value       = google_compute_instance.startup_demo.name
}

output "instance_id" {
  description = "ID of the created instance"
  value       = google_compute_instance.startup_demo.id
}

output "zone" {
  description = "Zone where the instance is deployed"
  value       = google_compute_instance.startup_demo.zone
}

# Network information
output "external_ip" {
  description = "External IP address of the instance"
  value       = google_compute_address.static_ip.address
}

output "internal_ip" {
  description = "Internal IP address of the instance"
  value       = google_compute_instance.startup_demo.network_interface[0].network_ip
}

# Dashboard access information
output "dashboard_url" {
  description = "URL to access the system monitoring dashboard"
  value       = "http://${google_compute_address.static_ip.address}"
}

output "dashboard_port" {
  description = "Port where the dashboard is running"
  value       = var.dashboard_port
}

output "alternative_dashboard_url" {
  description = "Alternative URL to access the dashboard directly"
  value       = "http://${google_compute_address.static_ip.address}:${var.dashboard_port}"
}

# SSH and connectivity information
output "ssh_command" {
  description = "Command to SSH into the instance"
  value       = "gcloud compute ssh ${google_compute_instance.startup_demo.name} --zone=${var.zone}"
}

output "ping_command" {
  description = "Command to test connectivity"
  value       = "ping ${google_compute_address.static_ip.address}"
}

# Startup script status check commands
output "check_startup_status" {
  description = "Commands to check startup script status"
  value = {
    check_log     = "gcloud compute ssh ${google_compute_instance.startup_demo.name} --zone=${var.zone} --command='cat /var/log/startup-script.log'"
    check_service = "gcloud compute ssh ${google_compute_instance.startup_demo.name} --zone=${var.zone} --command='systemctl status system-dashboard'"
    check_marker  = "gcloud compute ssh ${google_compute_instance.startup_demo.name} --zone=${var.zone} --command='ls -la /var/startup-script-completed'"
  }
}

# Health check endpoint
output "health_check_url" {
  description = "URL to check dashboard health status"
  value       = "http://${google_compute_address.static_ip.address}:${var.dashboard_port}/health"
}

# API endpoint
output "api_stats_url" {
  description = "URL to get raw system statistics in JSON format"
  value       = "http://${google_compute_address.static_ip.address}:${var.dashboard_port}/api/stats"
}

# Instance metadata
output "instance_metadata" {
  description = "Instance metadata including startup script info"
  value = {
    machine_type = var.machine_type
    boot_disk    = "${var.boot_disk_size}GB ${var.boot_disk_type}"
    preemptible  = "Yes - Using SPOT instance for cost savings"
    tags         = google_compute_instance.startup_demo.tags
    labels       = google_compute_instance.startup_demo.labels
  }
}