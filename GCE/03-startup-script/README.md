# 🚀 VM with Startup Script Automation Demo

## 📋 Overview

This demo showcases **startup script automation** on Google Cloud Platform VMs, demonstrating how to automatically configure and deploy applications when a VM boots. Instead of a boring "Hello World", we create a **real-time system health monitoring dashboard** that's automatically set up and running when the instance starts.

## 🎯 Purpose

- Demonstrate advanced startup script capabilities in GCP
- Show how to automate complex application deployments on boot
- Create a practical, creative example beyond simple echo statements
- Implement infrastructure automation best practices with Terraform

## 🎨 The Creative Approach

Our startup script creates a full-stack monitoring solution:
1. **Flask Web Application** - Python-based backend for system monitoring
2. **Beautiful Dashboard UI** - Real-time visualization with auto-refresh
3. **Nginx Reverse Proxy** - Professional web server setup
4. **Systemd Service** - Ensures the dashboard starts automatically
5. **Health Check Endpoints** - Production-ready monitoring capabilities

## 🏗️ Architecture

```
┌─────────────────────┐
│   User Browser      │
└──────────┬──────────┘
           │ HTTP
┌──────────▼──────────┐
│   Nginx (Port 80)   │──┐
└──────────┬──────────┘  │ Proxy
           │             │
┌──────────▼──────────┐  │
│  Flask App (:8080)  │◄─┘
├─────────────────────┤
│   System Monitor    │
│   - CPU Usage       │
│   - Memory Stats    │
│   - Disk Usage      │
│   - Network Info    │
└──────────┬──────────┘
           │
┌──────────▼──────────┐
│   psutil Library    │
│  (System Metrics)   │
└─────────────────────┘
```

## 💡 Key Features

### 1. Automated Setup
- Installs all dependencies (nginx, python3, flask, psutil)
- Creates application directory structure
- Deploys Python application code
- Configures systemd service
- Sets up nginx reverse proxy
- All happens automatically on boot!

### 2. Real-Time Dashboard
- **Live System Stats**: CPU, memory, disk usage
- **Network Information**: External/internal IPs
- **Instance Metadata**: Name, zone, platform
- **Auto-Refresh**: Updates every 5 seconds
- **Beautiful UI**: Gradient backgrounds, smooth animations

### 3. API Endpoints
- `/` - Main dashboard UI
- `/health` - Health check endpoint
- `/api/stats` - Raw JSON system statistics

## 📁 File Structure

```
03-startup-script/
├── providers.tf          # Provider configuration
├── variables.tf          # Variable definitions
├── network.tf           # VPC and firewall rules
├── main.tf              # Compute instance with startup script
├── outputs.tf           # Output values
├── startup-script.sh    # The creative startup script
├── terraform.tfvars     # Variable values (created at runtime)
├── demo-output.txt      # Demo execution log
└── README.md           # This file
```

## 🔧 Important Terraform Blocks

### 1. Startup Script Integration (main.tf)
```hcl
locals {
  startup_script = file("${path.module}/startup-script.sh")
}

resource "google_compute_instance" "startup_demo" {
  metadata = {
    startup-script = local.startup_script
  }
}
```
Reads the startup script from a file for better maintainability.

### 2. Comprehensive Firewall Rules (network.tf)
```hcl
# Multiple firewall rules for different services
- SSH (22) - Remote access
- HTTP (80) - Nginx proxy
- Dashboard (8080) - Direct Flask access
- ICMP - Connectivity testing
```

### 3. Resource Tagging (main.tf)
```hcl
labels = merge(
  var.common_tags,
  {
    instance_type = "startup-script-demo"
    has_dashboard = "true"
    dashboard_port = tostring(var.dashboard_port)
  }
)
```

### 4. Wait Timer (main.tf)
```hcl
resource "time_sleep" "wait_for_startup" {
  depends_on = [google_compute_instance.startup_demo]
  create_duration = "120s"
}
```
Ensures startup script has time to complete.

## 🎯 Success Criteria & Results

| Criteria | Result | Details |
|----------|---------|---------|
| VM Creation | ✅ Success | Instance created in Jakarta region |
| Startup Script Execution | ✅ Success | Completed automatically on boot |
| Dashboard Accessibility | ✅ Success | Available on ports 80 and 8080 |
| Real-time Stats | ✅ Success | Live CPU, memory, disk data |
| Health Endpoint | ✅ Success | Responds with healthy status |
| Auto-start Services | ✅ Success | systemd service active |

## 🚀 How to Use

1. **Deploy the infrastructure**:
   ```bash
   terraform init
   terraform apply
   ```

2. **Wait for startup script** (about 2-3 minutes)

3. **Access the dashboard**:
   - Main UI: `http://[EXTERNAL_IP]`
   - Direct Flask: `http://[EXTERNAL_IP]:8080`
   - Health Check: `http://[EXTERNAL_IP]/health`
   - API Stats: `http://[EXTERNAL_IP]:8080/api/stats`

4. **Check startup script logs**:
   ```bash
   gcloud compute ssh [INSTANCE_NAME] --zone=asia-southeast2-a \
     --command='sudo cat /var/log/startup-script.log'
   ```

5. **Clean up resources**:
   ```bash
   terraform destroy
   ```

## 📊 Dashboard Features

The dashboard displays:
- **System Information**: Hostname, platform, uptime
- **CPU Metrics**: Usage percentage, core count, frequency
- **Memory Stats**: Total, used, available with progress bars
- **Disk Usage**: Space utilization with visual indicators
- **Network Details**: External/internal IPs
- **Process Count**: Number of running processes

Visual features:
- 🎨 Gradient backgrounds
- 📊 Progress bars with color coding (green/yellow/red)
- ✨ Smooth animations
- 🔄 Auto-refresh indicator

## 💰 Cost Optimization

- **Preemptible/SPOT instance**: Up to 91% savings
- **e2-micro machine type**: Smallest available
- **10GB standard disk**: Minimum viable size
- **Jakarta region**: Competitive pricing

## 🔍 Startup Script Highlights

The startup script (`startup-script.sh`) demonstrates:
1. **Package management** - Installing multiple dependencies
2. **File creation** - Generating application code on the fly
3. **Service configuration** - Setting up systemd units
4. **Web server setup** - Configuring nginx as reverse proxy
5. **Error handling** - Logging to track execution
6. **Marker files** - Indicating successful completion

## ⚠️ Important Notes

- Instance uses preemptible/SPOT pricing (can be terminated)
- Firewall rules are open (0.0.0.0/0) - restrict in production
- Dashboard runs Flask development server - use WSGI in production
- Always destroy resources after testing to avoid charges