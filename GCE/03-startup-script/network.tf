# VPC Network for startup script demo
resource "google_compute_network" "vpc_network" {
  name                    = var.network_name
  auto_create_subnetworks = false
  description             = "VPC network for startup script automation demo"
}

# Subnet in Jakarta region
resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet_name
  network       = google_compute_network.vpc_network.id
  region        = var.region
  ip_cidr_range = var.subnet_cidr
  description   = "Subnet for startup script demo instances in Jakarta"
}

# Firewall rule to allow SSH access
resource "google_compute_firewall" "allow_ssh" {
  name    = "${var.network_name}-allow-ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  # Only allow SSH from specific IP ranges for better security
  source_ranges = ["0.0.0.0/0"] # In production, restrict this
  target_tags   = ["startup-script-ssh"]
  
  description = "Allow SSH access to startup script demo instance"
}

# Firewall rule to allow dashboard access on port 8080
resource "google_compute_firewall" "allow_dashboard" {
  name    = "${var.network_name}-allow-dashboard"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = [tostring(var.dashboard_port)]
  }

  source_ranges = ["0.0.0.0/0"] # Allow dashboard access from anywhere
  target_tags   = ["startup-script-dashboard"]
  
  description = "Allow access to system monitoring dashboard"
}

# Firewall rule to allow HTTP access on port 80
resource "google_compute_firewall" "allow_http" {
  name    = "${var.network_name}-allow-http"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"] # Allow HTTP access from anywhere
  target_tags   = ["startup-script-http"]
  
  description = "Allow HTTP access for nginx proxy"
}

# Firewall rule to allow ICMP (ping)
resource "google_compute_firewall" "allow_icmp" {
  name    = "${var.network_name}-allow-icmp"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["startup-script-ping"]
  
  description = "Allow ICMP for connectivity testing"
}