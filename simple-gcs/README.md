# Simple GCP VM with Terraform

This project demonstrates how to deploy a simple, cost-effective VM on Google Cloud Platform using Terraform.

## Overview

The configuration creates:
- A single e2-micro VM instance (the cheapest VM option)
- A firewall rule to allow HTTP traffic on port 80
- An external IP address for internet access
- Nginx web server with a custom welcome page

## Prerequisites

1. **Google Cloud Account**: You need an active GCP account
2. **Service Account Key**: Place your service account JSON key file in this directory
3. **Terraform**: Install Terraform on your local machine
4. **Enabled APIs**: Ensure the Compute Engine API is enabled in your GCP project

## Configuration

The main configuration file (`main.tf`) includes:

```hcl
provider "google" {
  credentials = file("your-service-account-key.json")
  project     = "your-project-id"
  region      = "asia-southeast2"  # Jakarta region
  zone        = "asia-southeast2-a"
}
```

### VM Specifications
- **Instance Type**: e2-micro (0.25 vCPU, 1GB memory)
- **Operating System**: Debian 11
- **Network**: Default VPC
- **Tags**: http-server (for firewall rule targeting)

## Usage

1. **Initialize Terraform**:
   ```bash
   terraform init
   ```

2. **Review the deployment plan**:
   ```bash
   terraform plan
   ```

3. **Deploy the infrastructure**:
   ```bash
   terraform apply
   ```

4. **Access your VM**:
   - The external IP will be displayed after deployment
   - Access via browser: `http://<external-ip>`

5. **Destroy the infrastructure** (when done):
   ```bash
   terraform destroy
   ```

## Cost Considerations

- **e2-micro**: This is the most cost-effective VM option in GCP
- **Region**: Choose a region close to your users for better performance
- **Always destroy**: Remember to destroy resources when not in use to avoid charges

## Security Notes

- The firewall rule allows HTTP traffic from any IP (0.0.0.0/0)
- For production use, consider:
  - Using HTTPS instead of HTTP
  - Restricting source IP ranges
  - Implementing proper authentication
  - Using Cloud IAP for secure access

## Files in this Directory

- `main.tf` - Main Terraform configuration
- `.terraform.lock.hcl` - Terraform dependency lock file
- `README.md` - This documentation file
- `*.json` - GCP service account credentials (not tracked in git)

## Troubleshooting

1. **API not enabled error**: Enable the Compute Engine API in your GCP project
2. **Permission denied**: Ensure your service account has the necessary permissions
3. **Resource limit**: Check your GCP quotas if deployment fails

## Next Steps

- Add a load balancer for high availability
- Use managed instance groups for auto-scaling
- Implement HTTPS with a managed SSL certificate
- Set up monitoring and alerting
- Use Cloud Storage for static assets