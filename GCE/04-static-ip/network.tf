# VPC Network for static IP demo
resource "google_compute_network" "vpc_network" {
  name                    = var.network_name
  auto_create_subnetworks = false
  description             = "VPC network for static IP reservation demo"
}

# Subnet in Jakarta region
resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet_name
  network       = google_compute_network.vpc_network.id
  region        = var.region
  ip_cidr_range = var.subnet_cidr
  description   = "Subnet for static IP demo instances in Jakarta"
}

# Firewall rule to allow SSH access
resource "google_compute_firewall" "allow_ssh" {
  name    = "${var.network_name}-allow-ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"] # In production, restrict this
  target_tags   = ["static-ip-ssh"]
  
  description = "Allow SSH access to static IP demo instance"
}

# Firewall rule to allow HTTP access
resource "google_compute_firewall" "allow_http" {
  name    = "${var.network_name}-allow-http"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["static-ip-http"]
  
  description = "Allow HTTP access for nginx"
}

# Firewall rule to allow service access
resource "google_compute_firewall" "allow_service" {
  name    = "${var.network_name}-allow-service"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = [tostring(var.service_port)]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["static-ip-service"]
  
  description = "Allow access to IP info service"
}

# Firewall rule to allow ICMP (ping)
resource "google_compute_firewall" "allow_icmp" {
  name    = "${var.network_name}-allow-icmp"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["static-ip-ping"]
  
  description = "Allow ICMP for connectivity testing"
}