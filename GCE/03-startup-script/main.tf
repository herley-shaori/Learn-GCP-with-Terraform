# Main configuration for startup script automation demo

# Random suffix for unique naming
resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

# Create a static external IP address
resource "google_compute_address" "static_ip" {
  name         = "${var.instance_name}-ip-${random_string.suffix.result}"
  region       = var.region
  address_type = "EXTERNAL"
  description  = "Static IP for startup script demo instance"
}

# Local variables for resource configuration
locals {
  # Read startup script from file
  startup_script = file("${path.module}/startup-script.sh")
  
  # Instance labels combining common tags and specific metadata
  instance_labels = merge(
    var.common_tags,
    {
      instance_type = "startup-script-demo"
      has_dashboard = "true"
      dashboard_port = tostring(var.dashboard_port)
    }
  )
}

# Compute instance with creative startup script
resource "google_compute_instance" "startup_demo" {
  name         = "${var.instance_name}-${random_string.suffix.result}"
  machine_type = var.machine_type
  zone         = var.zone
  
  # Apply all necessary tags for firewall rules
  tags = [
    "startup-script-ssh",
    "startup-script-dashboard",
    "startup-script-http",
    "startup-script-ping"
  ]
  
  # Apply comprehensive labels
  labels = local.instance_labels
  
  # Boot disk configuration - using minimal resources for cost optimization
  boot_disk {
    initialize_params {
      image = var.boot_disk_image
      size  = var.boot_disk_size
      type  = var.boot_disk_type
      
      labels = merge(
        var.common_tags,
        {
          instance = "${var.instance_name}-${random_string.suffix.result}"
        }
      )
    }
  }
  
  # Network interface with external IP
  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.subnet.id
    
    # Assign the static external IP
    access_config {
      nat_ip = google_compute_address.static_ip.address
    }
  }
  
  # Metadata including the creative startup script
  metadata = {
    # The startup script that creates the monitoring dashboard
    startup-script = local.startup_script
    
    # Additional metadata for tracking
    created-by     = "terraform"
    demo-type      = "startup-script-automation"
    dashboard-url  = "http://${google_compute_address.static_ip.address}"
  }
  
  # Use preemptible instance for cost savings
  scheduling {
    preemptible       = true
    automatic_restart = false
    provisioning_model = "SPOT"
  }
  
  # Instance description
  description = "Demo instance showcasing creative startup script automation with system monitoring dashboard"
  
  # Ensure network is created first
  depends_on = [
    google_compute_network.vpc_network,
    google_compute_subnetwork.subnet
  ]
}

# Wait time for startup script to complete
resource "time_sleep" "wait_for_startup" {
  depends_on = [google_compute_instance.startup_demo]
  
  # Wait 2 minutes for startup script to complete
  create_duration = "120s"
}