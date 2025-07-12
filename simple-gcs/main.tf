terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  credentials = file("learn-gcp-465712-16bdad8c3ce1.json")
  project     = "learn-gcp-465712"
  region      = "us-central1"
  zone        = "us-central1-a"
}

# Create a simple firewall rule to allow HTTP traffic
resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

# Create the VM instance
resource "google_compute_instance" "simple_vm" {
  name         = "simple-vm"
  machine_type = "e2-micro"  # Cheapest instance type
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {
      # This creates an external IP
    }
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y nginx
    systemctl start nginx
    systemctl enable nginx
    echo "<h1>Hello from GCP VM!</h1>" > /var/www/html/index.html
  EOF

  tags = ["http-server"]
}

# Output the external IP
output "external_ip" {
  value = google_compute_instance.simple_vm.network_interface[0].access_config[0].nat_ip
}