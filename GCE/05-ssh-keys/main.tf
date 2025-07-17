# Main configuration for SSH Keys Management Demo

# Get the SSH public key content
locals {
  ssh_public_key = file("${path.module}/demo-key.pub")
  
  # Format SSH key for GCP metadata
  ssh_keys_metadata = "${var.ssh_username}:${local.ssh_public_key}"
}

# Create a VPC network for our demo
resource "google_compute_network" "demo_network" {
  name                    = "ssh-keys-demo-network"
  auto_create_subnetworks = false
}

# Create a subnet in Jakarta region
resource "google_compute_subnetwork" "demo_subnet" {
  name          = "ssh-keys-demo-subnet"
  network       = google_compute_network.demo_network.id
  region        = var.region
  ip_cidr_range = "10.0.1.0/24"
  
  # Enable Private Google Access
  private_ip_google_access = true
}

# Firewall rule to allow SSH access
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh-demo"
  network = google_compute_network.demo_network.name
  
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  
  # Allow SSH from anywhere for demo purposes
  # In production, restrict source_ranges to specific IPs
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh-demo"]
}

# Firewall rule to allow HTTP access for demo web server
resource "google_compute_firewall" "allow_http" {
  name    = "allow-http-demo"
  network = google_compute_network.demo_network.name
  
  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
  
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh-demo"]
}

# Create the compute instance with SSH keys
resource "google_compute_instance" "ssh_demo_vm" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone
  
  # Use Ubuntu 22.04 LTS for better compatibility
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 10  # Minimum size to keep costs low
      type  = "pd-standard"  # Cheapest disk type
    }
  }
  
  network_interface {
    network    = google_compute_network.demo_network.name
    subnetwork = google_compute_subnetwork.demo_subnet.name
    
    # Assign external IP for SSH access
    access_config {
      # Ephemeral IP (free tier)
    }
  }
  
  # Metadata including SSH keys and startup script
  metadata = {
    # Add SSH keys via metadata
    ssh-keys = local.ssh_keys_metadata
    
    # Add startup script
    startup-script = file("${path.module}/startup-script.sh")
    
    # Additional metadata for demonstration
    demo-purpose = "ssh-key-management"
    created-by   = "terraform"
  }
  
  # Tags for firewall rules
  tags = ["ssh-demo"]
  
  # Labels for resource organization
  labels = var.labels
  
  # Enable serial port for debugging
  enable_display = true
  
  # Service account with minimal permissions
  service_account {
    scopes = ["cloud-platform"]
  }
}

# Note: Project-wide SSH keys can be managed as an alternative method
# Commented out as project already has ssh-keys metadata configured
# resource "google_compute_project_metadata_item" "ssh_keys" {
#   key   = "ssh-keys"
#   value = "${var.ssh_username}-project:${local.ssh_public_key}"
# }