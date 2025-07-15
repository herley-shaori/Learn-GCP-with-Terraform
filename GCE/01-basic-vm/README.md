# 🚀 GCE Basic VM Demo

## 📋 Overview

This demo showcases the fundamentals of creating a Google Compute Engine (GCE) virtual machine instance using Terraform. It demonstrates a simple yet complete infrastructure setup with proper tagging, networking, and web server deployment in the Jakarta region (asia-southeast2).

## 🎯 Purpose

The purpose of this demo is to:
- Create a basic GCE instance with minimal configuration
- Deploy a simple web server to verify connectivity
- Demonstrate Terraform best practices with proper file organization
- Show how to implement resource tagging for better management
- Provide a foundation for more complex GCE deployments

## 🏗️ Architecture

```
┌─────────────────────────────────────┐
│         Internet                    │
└──────────────┬──────────────────────┘
               │
               │ HTTP (Port 80)
               │
    ┌──────────▼──────────────┐
    │   Firewall Rule         │
    │  (Allow HTTP Traffic)   │
    └──────────┬──────────────┘
               │
    ┌──────────▼──────────────┐
    │    GCE Instance         │
    │   basic-vm-demo         │
    │  ┌────────────────┐     │
    │  │   Nginx Server │     │
    │  │   Port 80      │     │
    │  └────────────────┘     │
    │  Ubuntu 22.04 LTS       │
    │  e2-micro instance      │
    └─────────────────────────┘
```

## 📁 File Structure

```
01-basic-vm/
├── provider.tf     # Provider configuration and Terraform requirements
├── variables.tf    # Variable definitions with defaults
├── main.tf        # Main resource definitions (VM and firewall)
├── outputs.tf     # Output values for easy access to instance details
├── demo-output.txt # Execution journey documentation
└── README.md      # This file
```

## 🔧 Key Terraform Components

### Provider Configuration (provider.tf)
```hcl
provider "google" {
  credentials = file("~/Downloads/learn-gcp-465712-b4619fb17de4.json")
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}
```
- Configures the Google Cloud provider
- Sets the Jakarta region (asia-southeast2) as default
- Uses service account credentials for authentication

### VM Instance Resource (main.tf)
```hcl
resource "google_compute_instance" "basic_vm" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone
  
  # Boot disk, network, metadata configuration...
}
```
- Creates an e2-micro instance (cost-effective for demos)
- Configures Ubuntu 22.04 LTS as the operating system
- Includes startup script to install and configure nginx
- Assigns public IP for external access

### Firewall Rule (main.tf)
```hcl
resource "google_compute_firewall" "allow_http" {
  name    = "${var.instance_name}-allow-http"
  network = "default"
  
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
}
```
- Opens port 80 for HTTP traffic
- Uses target tags for selective application

### Resource Tagging
All resources include proper labels:
- `environment: demo`
- `purpose: basic-vm-poc`
- `managed_by: terraform`

## 🎯 Success Criteria

The PoC is considered successful when:
1. ✅ VM instance is created successfully
2. ✅ Instance responds to ping requests
3. ✅ Web server is accessible via HTTP
4. ✅ Custom welcome page is displayed
5. ✅ All resources are properly tagged

## 📊 Results

### ✅ PoC Status: **SUCCESS**

All success criteria have been met:

1. **VM Creation**: Instance `basic-vm-demo` created successfully in zone `asia-southeast2-a`
2. **Network Connectivity**: VM responds to ping with 0% packet loss
3. **Web Server**: Nginx installed and serving content on port 80
4. **Custom Content**: Welcome page displays proper information about the instance
5. **Resource Management**: All resources tagged appropriately

### Access Information
- **Web URL**: http://34.101.180.148
- **Instance Name**: basic-vm-demo
- **Zone**: asia-southeast2-a
- **Machine Type**: e2-micro

## 🚀 How to Use This Demo

1. **Initialize Terraform**:
   ```bash
   terraform init
   ```

2. **Review the plan**:
   ```bash
   terraform plan
   ```

3. **Apply the configuration**:
   ```bash
   terraform apply
   ```

4. **Access the web server**:
   - Open the URL shown in the outputs
   - Or use: `curl $(terraform output -raw web_url)`

5. **Clean up resources**:
   ```bash
   terraform destroy
   ```

## 📝 Key Learnings

- GCE instances can be quickly provisioned with Terraform
- Startup scripts enable automatic configuration on boot
- Proper tagging helps with resource organization and cost tracking
- Firewall rules are essential for controlling access
- The e2-micro instance type is perfect for simple demos

## 🔄 Next Steps

This basic demo provides a foundation for more advanced scenarios:
- Add load balancing for high availability
- Implement auto-scaling with managed instance groups
- Use custom machine types for specific workloads
- Add persistent disks for data storage
- Implement VPC networking for better security

## 📚 Resources

- [Google Compute Engine Documentation](https://cloud.google.com/compute/docs)
- [Terraform Google Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [GCE Machine Types](https://cloud.google.com/compute/docs/machine-types)