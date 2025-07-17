# Output values for the static IP demo

# Static IP address information
output "static_ip_address" {
  description = "The reserved static external IP address"
  value       = google_compute_address.static_ip.address
}

output "static_ip_name" {
  description = "The name of the static IP resource"
  value       = google_compute_address.static_ip.name
}

output "static_ip_self_link" {
  description = "The URI of the static IP resource"
  value       = google_compute_address.static_ip.self_link
}

# Instance information
output "instance_name" {
  description = "The name of the compute instance"
  value       = google_compute_instance.static_ip_instance.name
}

output "instance_id" {
  description = "The unique ID of the instance"
  value       = google_compute_instance.static_ip_instance.instance_id
}

output "instance_internal_ip" {
  description = "The internal IP address of the instance"
  value       = google_compute_instance.static_ip_instance.network_interface[0].network_ip
}

# Service access URLs
output "service_url" {
  description = "URL to access the IP information service"
  value       = "http://${google_compute_address.static_ip.address}"
}

output "service_api_url" {
  description = "API endpoint for IP information"
  value       = "http://${google_compute_address.static_ip.address}/api/info"
}

output "service_health_url" {
  description = "Health check endpoint"
  value       = "http://${google_compute_address.static_ip.address}/health"
}

# SSH connection command
output "ssh_command" {
  description = "Command to SSH into the instance"
  value       = "gcloud compute ssh ${google_compute_instance.static_ip_instance.name} --zone=${var.zone} --project=${var.project_id}"
}

# Important notes for demo
output "demo_notes" {
  description = "Important information about this demo"
  value = {
    purpose = "This demo shows how static IPs persist across instance lifecycle"
    test_persistence = "Stop/start or delete/recreate the instance - the IP remains the same"
    cost_optimization = "Using preemptible instance and minimal resources for cost savings"
    region = "Jakarta (asia-southeast2) for regional cost optimization"
  }
}