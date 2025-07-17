# This file defines all input variables for the Terraform configuration
# Variables make the code reusable and allow customization without modifying the main code
# Each variable can have a type, description, default value, and validation rules

# GCP Project Configuration
# -------------------------

# The GCP project ID where all resources will be created
# You can find this in the GCP Console or by running: gcloud config get-value project
variable "project_id" {
  description = "The GCP project ID"
  type        = string  # Ensures the value is a string
  # No default - must be provided by user
}

# Path to the service account credentials file (optional)
# If not specified, other authentication methods will be used
variable "credentials_file" {
  description = "Path to the GCP service account credentials JSON file"
  type        = string
  default     = ""  # Empty string means use default authentication
}

# Regional Configuration
# ----------------------

# The GCP region determines the geographic location of your resources
# asia-southeast2 is Jakarta, Indonesia
# Full list of regions: https://cloud.google.com/compute/docs/regions-zones
variable "region" {
  description = "The GCP region for resources"
  type        = string
  default     = "asia-southeast2"  # Jakarta region for compliance with requirements
}

# The specific zone within the region
# Zones are isolated locations within regions
# Format: {region}-{zone-letter} (e.g., asia-southeast2-a, asia-southeast2-b, etc.)
variable "zone" {
  description = "The GCP zone for resources"
  type        = string
  default     = "asia-southeast2-a"  # First zone in Jakarta region
}

# Instance Configuration
# ----------------------

# Name of the VM instance - must be unique within the project
# Naming convention: lowercase letters, numbers, and hyphens
# Must start with a letter, max 63 characters
variable "instance_name" {
  description = "Name of the GCE instance"
  type        = string
  default     = "basic-vm-demo"
}

# Machine type determines CPU and memory allocation
# e2-micro: 2 vCPUs (shared), 1GB memory - suitable for light workloads
# Other options: e2-small, e2-medium, n1-standard-1, etc.
# Full list: https://cloud.google.com/compute/docs/machine-types
variable "machine_type" {
  description = "Machine type for the instance"
  type        = string
  default     = "e2-micro"  # Cost-effective for demos (included in free tier)
}

# Operating System Configuration
# ------------------------------

# Image family ensures you get the latest version of an OS
# Format: {os-name}-{version}-{type}
# Examples: ubuntu-2204-lts, debian-11, centos-7
variable "image_family" {
  description = "Image family for the boot disk"
  type        = string
  default     = "ubuntu-2204-lts"  # Ubuntu 22.04 LTS (Long Term Support)
}

# The GCP project that maintains the OS images
# Common projects:
# - ubuntu-os-cloud: Ubuntu images
# - debian-cloud: Debian images
# - centos-cloud: CentOS images
# - windows-cloud: Windows Server images
variable "image_project" {
  description = "Project for the boot disk image"
  type        = string
  default     = "ubuntu-os-cloud"
}

# Resource Management
# -------------------

# Labels are key-value pairs for organizing and tracking resources
# Best practices:
# - Use lowercase letters, numbers, hyphens, and underscores
# - Keys must start with a lowercase letter
# - Maximum 63 characters per key or value
# Common label keys: environment, team, cost-center, application, owner
variable "labels" {
  description = "Labels to apply to resources"
  type        = map(string)  # Map allows key-value pairs
  default = {
    environment = "demo"         # Identifies this as a demo/test environment
    purpose     = "basic-vm-poc" # Describes the purpose of the resource
    managed_by  = "terraform"    # Indicates infrastructure as code management
  }
}

# Note: Variables can be overridden in several ways:
# 1. Command line: terraform apply -var="instance_name=my-vm"
# 2. Variable file: terraform apply -var-file="custom.tfvars"
# 3. Environment variables: export TF_VAR_instance_name="my-vm"
# 4. Interactive prompt: Terraform will ask for values if no default is set