# Project configuration variables
variable "project_id" {
  description = "The GCP project ID"
  type        = string
  # No default - must be provided by user
}

variable "region" {
  description = "The GCP region for resources"
  type        = string
  default     = "asia-southeast2" # Jakarta region
}

variable "zone" {
  description = "The GCP zone for resources"
  type        = string
  default     = "asia-southeast2-a" # Jakarta zone
}

variable "credentials_path" {
  description = "Path to the GCP credentials JSON file"
  type        = string
  default     = "" # Empty string means use default authentication
}

# Network configuration
variable "network_name" {
  description = "Name of the VPC network"
  type        = string
  default     = "custom-machine-vpc"
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
  default     = "custom-machine-subnet"
}

variable "subnet_cidr" {
  description = "CIDR range for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

# Machine configuration
variable "machine_configs" {
  description = "Map of custom machine configurations"
  type = map(object({
    machine_type = string
    vcpus        = number
    memory_mb    = number
    description  = string
  }))
  default = {
    "micro" = {
      machine_type = "custom-1-1024"     # 1 vCPU, 1GB RAM
      vcpus        = 1
      memory_mb    = 1024
      description  = "Micro instance: 1 vCPU, 1GB RAM - Cheapest option"
    }
    "small" = {
      machine_type = "custom-1-2048"     # 1 vCPU, 2GB RAM
      vcpus        = 1
      memory_mb    = 2048
      description  = "Small instance: 1 vCPU, 2GB RAM - Budget option"
    }
    "standard" = {
      machine_type = "custom-2-2048"     # 2 vCPUs, 2GB RAM
      vcpus        = 2
      memory_mb    = 2048
      description  = "Standard instance: 2 vCPUs, 2GB RAM - Balanced option"
    }
  }
}

# Instance configuration
variable "selected_machine_type" {
  description = "Selected machine type from machine_configs (micro, small, or standard)"
  type        = string
  default     = "micro" # Start with the cheapest option
}

variable "instance_name_prefix" {
  description = "Prefix for instance names"
  type        = string
  default     = "custom-machine-demo"
}

variable "boot_disk_size" {
  description = "Size of the boot disk in GB"
  type        = number
  default     = 10 # Minimum disk size to reduce costs
}

variable "boot_disk_type" {
  description = "Type of boot disk"
  type        = string
  default     = "pd-standard" # Cheapest disk type
}

variable "boot_disk_image" {
  description = "Boot disk image"
  type        = string
  default     = "debian-cloud/debian-11" # Free OS option
}

# Common tags
variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    environment = "demo"
    project     = "custom-machine-types"
    managed_by  = "terraform"
    region      = "jakarta"
    purpose     = "poc"
  }
}