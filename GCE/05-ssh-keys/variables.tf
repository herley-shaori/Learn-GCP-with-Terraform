# Project configuration variables
variable "project_id" {
  description = "GCP Project ID where resources will be created"
  type        = string
}

variable "region" {
  description = "GCP region for resource deployment"
  type        = string
  default     = "asia-southeast2"  # Jakarta region
}

variable "zone" {
  description = "GCP zone for compute instance deployment"
  type        = string
  default     = "asia-southeast2-a"  # Jakarta zone
}

# VM configuration variables
variable "instance_name" {
  description = "Name of the compute instance"
  type        = string
  default     = "ssh-keys-demo-vm"
}

variable "machine_type" {
  description = "Machine type for the compute instance"
  type        = string
  default     = "e2-micro"  # Cheapest option for demo
}

# SSH configuration
variable "ssh_username" {
  description = "Username for SSH access"
  type        = string
  default     = "demo-user"
}

# Labels for resource organization
variable "labels" {
  description = "Labels to apply to all resources"
  type        = map(string)
  default = {
    environment = "demo"
    purpose     = "ssh-keys-management"
    managed-by  = "terraform"
  }
}