# Output values for the SSH Keys Demo

output "instance_name" {
  description = "Name of the created compute instance"
  value       = google_compute_instance.ssh_demo_vm.name
}

output "instance_external_ip" {
  description = "External IP address of the instance"
  value       = google_compute_instance.ssh_demo_vm.network_interface[0].access_config[0].nat_ip
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i ${path.module}/demo-key ${var.ssh_username}@${google_compute_instance.ssh_demo_vm.network_interface[0].access_config[0].nat_ip}"
}

output "web_server_url" {
  description = "URL to access the SSH info web server"
  value       = "http://${google_compute_instance.ssh_demo_vm.network_interface[0].access_config[0].nat_ip}:8080"
}

output "instance_id" {
  description = "Instance ID"
  value       = google_compute_instance.ssh_demo_vm.instance_id
}

output "zone" {
  description = "Zone where the instance is deployed"
  value       = google_compute_instance.ssh_demo_vm.zone
}

output "ssh_key_fingerprint" {
  description = "Fingerprint of the SSH key used"
  value       = trimspace(file("${path.module}/demo-key.pub"))
}