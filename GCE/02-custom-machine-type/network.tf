# VPC Network for custom machine instances
resource "google_compute_network" "vpc_network" {
  name                    = var.network_name
  auto_create_subnetworks = false
  description             = "VPC network for custom machine type demo"
}

# Subnet in Jakarta region
resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet_name
  network       = google_compute_network.vpc_network.id
  region        = var.region
  ip_cidr_range = var.subnet_cidr
  description   = "Subnet for custom machine type instances in Jakarta"
}

# Firewall rule to allow SSH access
resource "google_compute_firewall" "allow_ssh" {
  name    = "${var.network_name}-allow-ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"] # Allow SSH from anywhere (for demo only)
  target_tags   = ["custom-machine-ssh"]
  
  description = "Allow SSH access to custom machine instances"
}

# Firewall rule to allow ICMP (ping)
resource "google_compute_firewall" "allow_icmp" {
  name    = "${var.network_name}-allow-icmp"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"] # Allow ping from anywhere (for demo only)
  target_tags   = ["custom-machine-ping"]
  
  description = "Allow ICMP (ping) to custom machine instances"
}

# Firewall rule to allow HTTP access for testing
resource "google_compute_firewall" "allow_http" {
  name    = "${var.network_name}-allow-http"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"] # Allow HTTP from anywhere (for demo only)
  target_tags   = ["custom-machine-http"]
  
  description = "Allow HTTP access to custom machine instances"
}