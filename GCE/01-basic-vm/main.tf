# This file contains the main resource definitions for our basic VM demo
# It creates a Google Compute Engine instance and associated firewall rule

# Resource: Google Compute Engine Instance
# ----------------------------------------
# This resource creates a virtual machine in Google Cloud Platform
# Resource naming: "google_compute_instance" is the resource type
# "basic_vm" is the local name we'll use to reference this resource

resource "google_compute_instance" "basic_vm" {
  # Basic instance configuration
  # These are the minimum required parameters for a GCE instance
  
  # Instance name - must be unique within the project
  # This will be the hostname and display name in GCP Console
  name         = var.instance_name
  
  # Machine type defines the virtual hardware (CPU, memory)
  # e2-micro: 2 vCPUs (0.25 vCPU burst), 1GB memory
  # Pricing: https://cloud.google.com/compute/vm-instance-pricing
  machine_type = var.machine_type
  
  # Zone where the instance will be created
  # Instances are zonal resources (exist in a specific zone)
  zone         = var.zone

  # Boot Disk Configuration
  # -----------------------
  # Every instance needs a boot disk with an operating system
  boot_disk {
    # initialize_params is used when creating a new disk from an image
    initialize_params {
      # OS image in format: project/family or project/image
      # Using family ensures we get the latest image in that family
      image = "${var.image_project}/${var.image_family}"
      
      # Disk size in GB - Ubuntu minimal requirement is ~10GB
      # 20GB provides room for packages and logs
      size  = 20
      
      # Disk type affects performance and cost:
      # - pd-standard: Standard persistent disk (HDD) - cheapest
      # - pd-balanced: Balanced persistent disk (SSD) - good price/performance
      # - pd-ssd: SSD persistent disk - highest performance
      type  = "pd-standard"
    }
  }

  # Network Configuration
  # ---------------------
  # Defines how the instance connects to networks and the internet
  network_interface {
    # Network to attach to - "default" is the auto-created VPC
    # In production, you'd typically use a custom VPC
    network = "default"
    
    # access_config block assigns an external (public) IP
    # Without this, the instance would only have an internal IP
    access_config {
      # Empty block = ephemeral IP (changes on stop/start)
      # To use static IP: nat_ip = google_compute_address.static.address
    }
  }

  # Instance Metadata
  # -----------------
  # Metadata is key-value data accessible by the instance
  # Used for configuration and startup scripts
  metadata = {
    # OS Login allows SSH access using Google Cloud IAM
    # Setting to FALSE uses traditional SSH keys instead
    # TRUE is more secure but requires additional IAM setup
    enable-oslogin = "FALSE"
  }

  # Startup Script
  # --------------
  # Runs automatically when the instance boots
  # Useful for software installation and initial configuration
  # Note: Use <<-EOF for multi-line strings (heredoc syntax)
  metadata_startup_script = <<-EOF
    #!/bin/bash
    # This script runs as root during instance startup
    
    # Update package list to get latest versions
    apt-get update
    
    # Install nginx web server
    # -y flag auto-confirms installation
    apt-get install -y nginx
    
    # Start nginx service immediately
    systemctl start nginx
    
    # Enable nginx to start on boot
    systemctl enable nginx
    
    # Create custom welcome page
    # This demonstrates that our VM is working correctly
    cat > /var/www/html/index.html <<HTML
    <!DOCTYPE html>
    <html>
    <head>
        <title>GCE Basic VM Demo</title>
    </head>
    <body>
        <h1>Hello from GCE Basic VM!</h1>
        <p>This VM is running in Jakarta region (asia-southeast2)</p>
        <p>Instance Name: ${var.instance_name}</p>
        <p>Zone: ${var.zone}</p>
    </body>
    </html>
    HTML
  EOF

  # Resource Labels
  # ---------------
  # Labels are key-value pairs for organizing resources
  # Used for billing breakdown, access control, and filtering
  labels = var.labels

  # Network Tags
  # ------------
  # Tags are used by firewall rules to target specific instances
  # This tag will be referenced by our firewall rule below
  tags = ["http-server"]
}

# Resource: Firewall Rule
# -----------------------
# GCP blocks all incoming traffic by default (secure by default)
# We need to explicitly allow HTTP traffic to reach our web server

resource "google_compute_firewall" "allow_http" {
  # Firewall rule name - must be unique within the project
  # Using instance name as prefix for easy identification
  name    = "${var.instance_name}-allow-http"
  
  # Network where this rule applies
  # Must match the instance's network
  network = "default"

  # Traffic to allow
  # Multiple allow blocks can be specified for different protocols/ports
  allow {
    # Protocol: tcp, udp, icmp, esp, ah, sctp, or protocol number
    protocol = "tcp"
    
    # List of ports to allow
    # Common ports: 80 (HTTP), 443 (HTTPS), 22 (SSH), 3389 (RDP)
    ports    = ["80"]
  }

  # Source IP ranges that can access
  # 0.0.0.0/0 means anywhere on the internet (use with caution!)
  # For better security, restrict to specific IPs or ranges
  # Example: ["203.0.113.0/24", "198.51.100.0/24"]
  source_ranges = ["0.0.0.0/0"]
  
  # Target tags - which instances this rule applies to
  # Matches the tags on our instance above
  # Without target_tags, rule would apply to ALL instances in the network
  target_tags   = ["http-server"]
}

# Additional Notes:
# -----------------
# 1. This creates the most basic VM setup suitable for demos
# 2. For production, consider:
#    - Custom VPC instead of default network
#    - Private IP only with Cloud NAT for outbound
#    - Managed instance groups for high availability
#    - Load balancing for traffic distribution
#    - More restrictive firewall rules
#    - Regular snapshots for backup
# 3. Costs to consider:
#    - Instance running time (billed per second)
#    - Persistent disk storage
#    - Network egress (outbound traffic)
#    - Static IP addresses (if used)