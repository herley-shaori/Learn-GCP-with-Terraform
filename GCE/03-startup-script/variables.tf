# Project configuration variables
variable "project_id" {
  description = "The GCP project ID"
  type        = string
  default     = "learn-gcp-465712"
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
  default     = "~/Downloads/learn-gcp-465712-b4619fb17de4.json"
}

# Instance configuration
variable "instance_name" {
  description = "Name of the compute instance"
  type        = string
  default     = "startup-script-demo"
}

variable "machine_type" {
  description = "Machine type for the instance"
  type        = string
  default     = "e2-micro" # Cheapest instance type
}

variable "boot_disk_image" {
  description = "Boot disk image for the instance"
  type        = string
  default     = "debian-cloud/debian-11"
}

variable "boot_disk_size" {
  description = "Boot disk size in GB"
  type        = number
  default     = 10
}

variable "boot_disk_type" {
  description = "Boot disk type"
  type        = string
  default     = "pd-standard" # Cheapest disk type
}

# Network configuration
variable "network_name" {
  description = "Name of the VPC network"
  type        = string
  default     = "startup-script-vpc"
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
  default     = "startup-script-subnet"
}

variable "subnet_cidr" {
  description = "CIDR range for the subnet"
  type        = string
  default     = "10.0.2.0/24"
}

# Common tags
variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    environment = "demo"
    project     = "startup-script-automation"
    managed_by  = "terraform"
    region      = "jakarta"
    purpose     = "poc"
  }
}

# Dashboard configuration
variable "dashboard_port" {
  description = "Port for the system dashboard"
  type        = number
  default     = 8080
}

variable "refresh_interval" {
  description = "Dashboard refresh interval in seconds"
  type        = number
  default     = 5
}