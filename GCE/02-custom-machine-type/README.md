# 🚀 GCP Custom Machine Types Demo

## 📋 Overview

This demo showcases how to use **custom machine types** in Google Cloud Platform (GCP) to create cost-optimized virtual machines with precise resource allocation. Instead of using predefined machine types, we create instances with exactly the vCPUs and memory needed.

## 🎯 Purpose

- Demonstrate the flexibility of GCP custom machine types
- Show cost optimization strategies for VM deployment
- Implement Terraform best practices for infrastructure as code
- Test three different custom configurations optimized for cost

## 🏗️ Architecture

### Custom Machine Type Configurations

| Configuration | Machine Type | vCPUs | Memory | Use Case |
|--------------|--------------|-------|---------|----------|
| **Micro** | custom-1-1024 | 1 | 1GB | Minimal workloads, testing |
| **Small** | custom-1-2048 | 1 | 2GB | Light workloads, small apps |
| **Standard** | custom-2-2048 | 2 | 2GB | Balanced performance |

### Infrastructure Components

- **VPC Network**: Custom network for isolation
- **Subnet**: Located in Jakarta region (asia-southeast2)
- **Firewall Rules**: SSH, HTTP, and ICMP access
- **Static IP**: External IP for consistent access
- **Compute Instance**: Preemptible with startup script

## 💰 Cost Optimization Features

1. **Preemptible/Spot Instances**: Up to 91% cost savings
2. **Custom Machine Types**: Pay only for resources you need
3. **Minimal Boot Disk**: 10GB standard persistent disk
4. **Jakarta Region**: Competitive pricing in Southeast Asia

## 📁 File Structure

```
02-custom-machine-type/
├── providers.tf          # Provider configuration
├── variables.tf          # Variable definitions
├── network.tf           # VPC and firewall rules
├── main.tf              # Compute instance resources
├── outputs.tf           # Output values
├── terraform.tfvars     # Variable values (created at runtime)
├── demo-output.txt      # Demo execution log
└── README.md           # This file
```

## 🔧 Important Terraform Blocks

### 1. Custom Machine Type Definition (variables.tf)

```hcl
variable "machine_configs" {
  description = "Map of custom machine configurations"
  type = map(object({
    machine_type = string
    vcpus        = number
    memory_mb    = number
    description  = string
  }))
}
```

This allows easy switching between different custom configurations using a single variable.

### 2. Dynamic Instance Creation (main.tf)

```hcl
resource "google_compute_instance" "custom_machine" {
  machine_type = local.selected_config.machine_type
  
  scheduling {
    preemptible       = true
    automatic_restart = false
    provisioning_model = "SPOT"
  }
}
```

Uses preemptible instances for maximum cost savings.

### 3. Comprehensive Tagging (main.tf)

```hcl
labels = merge(
  var.common_tags,
  {
    machine_type_category = var.selected_machine_type
    vcpus                 = tostring(local.selected_config.vcpus)
    memory_mb             = tostring(local.selected_config.memory_mb)
  }
)
```

All resources are properly tagged for organization and cost tracking.

### 4. Startup Script with Instance Info

Each instance runs nginx with a custom page showing its specifications, making it easy to verify the deployment.

## 🎯 Success Criteria

✅ **All objectives achieved:**

1. Created three different custom machine type configurations
2. Successfully deployed each instance in Jakarta region
3. Verified connectivity via ping (0% packet loss)
4. Confirmed HTTP access with custom pages
5. Implemented comprehensive tagging
6. Applied multiple cost optimization strategies
7. Used Terraform best practices with modular code

## 📊 Test Results

| Instance | Ping Latency | HTTP Access | Cost Optimization |
|----------|-------------|-------------|------------------|
| Micro | 67.594ms | ✅ Success | Lowest cost |
| Small | 77.505ms | ✅ Success | Budget option |
| Standard | 46.166ms | ✅ Success | Best performance |

## 🚀 How to Use

1. **Set your machine type** in `terraform.tfvars`:
   ```hcl
   selected_machine_type = "micro"  # or "small" or "standard"
   ```

2. **Deploy the infrastructure**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

3. **Test connectivity**:
   ```bash
   # Ping test
   ping $(terraform output -raw external_ip)
   
   # HTTP test
   curl http://$(terraform output -raw external_ip)
   ```

4. **Switch between configurations**:
   - Update `selected_machine_type` in terraform.tfvars
   - Run `terraform apply` to recreate with new specs

5. **Clean up** (IMPORTANT):
   ```bash
   terraform destroy
   ```

## 💡 Key Learnings

1. **Custom machine types** provide exact resource allocation
2. **Preemptible instances** dramatically reduce costs for non-critical workloads
3. **Proper tagging** is essential for resource management
4. **Jakarta region** offers good performance for Southeast Asia
5. **Terraform variables** make configuration switching seamless

## ⚠️ Important Notes

- Always destroy resources after testing to avoid charges
- Preemptible instances can be terminated by GCP with 30-second notice
- Custom machine types must follow GCP's [requirements](https://cloud.google.com/compute/docs/instances/creating-instance-with-custom-machine-type)
- Memory must be between 0.9 GB and 6.5 GB per vCPU

## 🎉 POC Result

**✅ SUCCESS** - All custom machine types were successfully deployed, tested, and verified. The demo proves that custom machine types are an excellent way to optimize costs while getting exactly the resources needed for your workloads.