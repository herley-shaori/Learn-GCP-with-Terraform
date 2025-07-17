# Static IP reservation for persistent external access
resource "google_compute_address" "static_ip" {
  name         = var.static_ip_name
  region       = var.region
  address_type = "EXTERNAL"
  description  = "Reserved static external IP for demo instance"
  
  # Apply common tags as labels
  labels = var.common_tags
}

# Compute instance with static IP attached
resource "google_compute_instance" "static_ip_instance" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone
  
  # Instance description
  description = "Demo instance showcasing static IP reservation and persistence"
  
  # Boot disk configuration
  boot_disk {
    initialize_params {
      image = var.boot_disk_image
      size  = var.boot_disk_size
      type  = var.boot_disk_type
      
      # Apply labels to boot disk
      labels = merge(var.common_tags, {
        disk_type = "boot"
        instance  = var.instance_name
      })
    }
    
    # Keep disk on instance deletion for data persistence
    auto_delete = true
  }
  
  # Network interface with static IP
  network_interface {
    network    = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.subnet.name
    
    # Attach the reserved static IP
    access_config {
      nat_ip = google_compute_address.static_ip.address
    }
  }
  
  # Metadata for startup script
  metadata = {
    # Read startup script from file
    startup-script = file("${path.module}/startup-script.sh")
    
    # Additional metadata for demo purposes
    demo-type      = "static-ip-reservation"
    static-ip-name = google_compute_address.static_ip.name
    static-ip-addr = google_compute_address.static_ip.address
  }
  
  # Network tags for firewall rules
  tags = [
    "static-ip-ssh",
    "static-ip-http",
    "static-ip-service",
    "static-ip-ping"
  ]
  
  # Labels for resource organization
  labels = merge(var.common_tags, {
    demo_type    = "static_ip"
    has_static_ip = "true"
  })
  
  # Service account with minimal permissions
  service_account {
    # Use default compute service account
    scopes = [
      "https://www.googleapis.com/auth/compute.readonly",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write"
    ]
  }
  
  # Scheduling configuration for cost optimization
  scheduling {
    # Use preemptible instance for cost savings
    preemptible         = true
    automatic_restart   = false
    on_host_maintenance = "TERMINATE"
    
    # Preemptible instance can run for up to 24 hours
    provisioning_model = "SPOT"
  }
  
  # Allow HTTPS for potential future enhancements
  allow_stopping_for_update = true
  
  # Dependency to ensure static IP is created first
  depends_on = [
    google_compute_address.static_ip,
    google_compute_firewall.allow_ssh,
    google_compute_firewall.allow_http,
    google_compute_firewall.allow_service,
    google_compute_firewall.allow_icmp
  ]
}

# Resource to demonstrate IP persistence across instance recreations
resource "google_compute_project_metadata_item" "static_ip_demo_info" {
  key   = "static-ip-demo-${var.static_ip_name}"
  value = jsonencode({
    created_at    = timestamp()
    static_ip     = google_compute_address.static_ip.address
    instance_name = google_compute_instance.static_ip_instance.name
    region        = var.region
    demo_purpose  = "Demonstrates that static IPs persist even when instances are deleted and recreated"
  })
}