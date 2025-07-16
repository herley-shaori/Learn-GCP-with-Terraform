# Main configuration for custom machine type demo

# Local variables for selected machine configuration
locals {
  selected_config = var.machine_configs[var.selected_machine_type]
  
  # Merge common tags with instance-specific tags
  instance_labels = merge(
    var.common_tags,
    {
      machine_type_category = var.selected_machine_type
      vcpus                 = tostring(local.selected_config.vcpus)
      memory_mb             = tostring(local.selected_config.memory_mb)
    }
  )
}

# Create a static external IP address for the instance
resource "google_compute_address" "static_ip" {
  name         = "${var.instance_name_prefix}-${var.selected_machine_type}-ip"
  region       = var.region
  address_type = "EXTERNAL"
  description  = "Static IP for ${var.selected_machine_type} custom machine instance"
}

# Create the custom machine type instance
resource "google_compute_instance" "custom_machine" {
  name         = "${var.instance_name_prefix}-${var.selected_machine_type}"
  machine_type = local.selected_config.machine_type
  zone         = var.zone
  
  # Apply all tags for firewall rules
  tags = [
    "custom-machine-ssh",
    "custom-machine-ping", 
    "custom-machine-http"
  ]
  
  # Apply labels for resource organization
  labels = local.instance_labels
  
  # Boot disk configuration - using cheapest options
  boot_disk {
    initialize_params {
      image = var.boot_disk_image
      size  = var.boot_disk_size
      type  = var.boot_disk_type
      
      labels = merge(
        var.common_tags,
        {
          instance = "${var.instance_name_prefix}-${var.selected_machine_type}"
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
  
  # Metadata for SSH keys and startup script
  metadata = {
    # Simple startup script to install a basic web server for testing
    startup-script = <<-EOF
      #!/bin/bash
      # Update package list
      apt-get update
      
      # Install nginx for HTTP testing
      apt-get install -y nginx
      
      # Create a custom index page with instance information
      cat > /var/www/html/index.html <<-HTML
      <!DOCTYPE html>
      <html>
      <head>
          <title>Custom Machine Type Demo</title>
          <style>
              body { font-family: Arial, sans-serif; margin: 40px; }
              .info { background: #f0f0f0; padding: 20px; border-radius: 5px; }
              h1 { color: #333; }
              p { line-height: 1.6; }
              .spec { font-weight: bold; color: #0066cc; }
          </style>
      </head>
      <body>
          <h1>🚀 Custom Machine Type Demo - ${var.selected_machine_type}</h1>
          <div class="info">
              <h2>Instance Specifications:</h2>
              <p><span class="spec">Machine Type:</span> ${local.selected_config.machine_type}</p>
              <p><span class="spec">vCPUs:</span> ${local.selected_config.vcpus}</p>
              <p><span class="spec">Memory:</span> ${local.selected_config.memory_mb} MB</p>
              <p><span class="spec">Description:</span> ${local.selected_config.description}</p>
              <p><span class="spec">Zone:</span> ${var.zone}</p>
              <p><span class="spec">Instance Name:</span> ${var.instance_name_prefix}-${var.selected_machine_type}</p>
              <hr>
              <p>✅ This instance is running successfully!</p>
              <p>🏷️ Environment: ${var.common_tags.environment} | Project: ${var.common_tags.project}</p>
          </div>
      </body>
      </html>
      HTML
      
      # Restart nginx to ensure it's running
      systemctl restart nginx
      
      # Log startup completion
      echo "Startup script completed at $(date)" >> /var/log/startup-script.log
    EOF
  }
  
  # Use spot/preemptible instance for cost savings
  scheduling {
    preemptible       = true
    automatic_restart = false
    provisioning_model = "SPOT"
  }
  
  # Add description to the instance
  description = "${local.selected_config.description} - Demo instance in Jakarta"
  
  # Ensure the network is created first
  depends_on = [
    google_compute_network.vpc_network,
    google_compute_subnetwork.subnet
  ]
}