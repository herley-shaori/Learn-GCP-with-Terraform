# 🌐 GCP Static IP Reservation Demo

## 📋 Overview

This demo showcases how to reserve and use static external IP addresses in Google Cloud Platform using Terraform. Unlike ephemeral IPs that change when instances are stopped/started, static IPs persist and remain associated with your project even when not attached to any resource.

## 🎯 Purpose

- Demonstrate static IP reservation in GCP
- Show how static IPs persist across instance lifecycle
- Create an interactive IP information service
- Implement Terraform best practices for infrastructure as code
- Optimize costs while maintaining functionality

## 🏗️ Architecture

```
┌─────────────────────────────────────┐
│      Static IP (Reserved)           │
│        34.128.113.239               │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│      GCP Compute Instance           │
│        (e2-micro, SPOT)             │
│   ┌─────────────────────────────┐   │
│   │   IP Information Service    │   │
│   │      (Flask + Nginx)        │   │
│   └─────────────────────────────┘   │
└─────────────────────────────────────┘
```

## 🚀 Key Features

### Static IP Reservation
- **Persistent Address**: IP remains constant even after instance deletion
- **DNS Friendly**: Stable endpoint for DNS records
- **API Integration**: Consistent IP for external integrations

### Creative Service Implementation
- **Real-time Dashboard**: Interactive web interface showing IP information
- **API Endpoints**: JSON API for programmatic access
- **Persistence Tracking**: Shows how long the service has been running
- **Auto-refresh**: Updates information every 30 seconds

## 📁 File Structure

```
04-static-ip/
├── providers.tf          # GCP provider configuration
├── variables.tf          # Input variables and defaults
├── network.tf           # VPC and firewall rules
├── main.tf              # Static IP and compute instance
├── outputs.tf           # Output values
├── startup-script.sh    # Creative startup script
├── demo-output.txt      # Journey documentation
└── README.md           # This file
```

## 🔧 Important Terraform Blocks

### Static IP Reservation
```hcl
resource "google_compute_address" "static_ip" {
  name         = var.static_ip_name
  region       = var.region
  address_type = "EXTERNAL"
  description  = "Reserved static external IP for demo instance"
  labels       = var.common_tags
}
```

### Attaching Static IP to Instance
```hcl
network_interface {
  network    = google_compute_network.vpc_network.name
  subnetwork = google_compute_subnetwork.subnet.name
  
  access_config {
    nat_ip = google_compute_address.static_ip.address
  }
}
```

### Cost Optimization
```hcl
scheduling {
  preemptible         = true
  automatic_restart   = false
  on_host_maintenance = "TERMINATE"
  provisioning_model  = "SPOT"
}
```

## 🎯 Success Criteria

1. ✅ **Static IP Reserved**: Successfully reserved external IP address
2. ✅ **Instance Created**: VM deployed with static IP attached
3. ✅ **Service Deployed**: IP information service accessible via HTTP
4. ✅ **Persistence Demonstrated**: Service shows IP type and uptime
5. ✅ **Cost Optimized**: Using SPOT instance and minimal resources
6. ✅ **Properly Tagged**: All resources labeled for organization

## 🧪 Testing Results

### Service Accessibility
- Web Interface: `http://34.128.113.239/`
- API Endpoint: `http://34.128.113.239/api/info`
- Health Check: `http://34.128.113.239/health`

### API Response Example
```json
{
  "instance": {
    "external_ip": "34.128.113.239",
    "ip_type": "Static (Reserved)",
    "instance_name": "static-ip-demo",
    "zone": "asia-southeast2-a"
  },
  "persistence": {
    "first_startup": "2025-07-17T02:26:42",
    "uptime": "0:04:16"
  }
}
```

## 💰 Cost Optimization

- **Region**: Jakarta (asia-southeast2) for lower costs
- **Instance Type**: e2-micro (smallest available)
- **Scheduling**: SPOT/Preemptible for up to 91% savings
- **Disk**: Standard persistent disk, 10GB minimum
- **Static IP Cost**: ~$0.01/hour when attached, ~$0.01/hour when reserved but unattached

## 🔄 Static IP Persistence

To demonstrate persistence:
1. **Stop/Start Test**: Instance retains same IP after restart
2. **Delete/Recreate Test**: New instance can use same reserved IP
3. **Detach Test**: IP remains reserved even without instance

## 🎓 Key Learnings

1. **IP Reservation**: Static IPs are regional resources
2. **Cost Consideration**: Unused static IPs still incur charges
3. **Best Practice**: Release static IPs when not needed
4. **Persistence**: IPs survive instance lifecycle events

## 🏁 Demo Result

✅ **SUCCESS** - The static IP reservation demo achieved all objectives:
- Reserved static external IP in Jakarta region
- Deployed creative IP information service
- Demonstrated IP persistence capabilities
- Implemented cost optimization strategies
- Created interactive web interface
- All resources properly tagged and organized

## 🧹 Cleanup

To avoid ongoing charges:
```bash
terraform destroy -auto-approve
```

This will:
- Delete the compute instance
- Remove the static IP reservation
- Clean up VPC and firewall rules
- Remove all associated resources

## 📊 Resource Summary

- **Static IP**: 1x Reserved External IP
- **Compute**: 1x e2-micro SPOT instance
- **Network**: 1x VPC, 1x Subnet, 4x Firewall rules
- **Storage**: 10GB standard persistent disk
- **Region**: asia-southeast2 (Jakarta)