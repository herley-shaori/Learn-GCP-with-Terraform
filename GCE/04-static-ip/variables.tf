# Project configuration variables
variable "project_id" {
  description = "The GCP project ID"
  type        = string
  default     = "learn-gcp-465712"
}

variable "region" {
  description = "The GCP region for resources"
  type        = string
  default     = "asia-southeast2" # Jakarta region for cost optimization
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
  default     = "static-ip-demo"
}

variable "machine_type" {
  description = "Machine type for the instance"
  type        = string
  default     = "e2-micro" # Cheapest instance type for cost optimization
}

variable "boot_disk_image" {
  description = "Boot disk image for the instance"
  type        = string
  default     = "debian-cloud/debian-11"
}

variable "boot_disk_size" {
  description = "Boot disk size in GB"
  type        = number
  default     = 10 # Minimum size for cost optimization
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
  default     = "static-ip-vpc"
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
  default     = "static-ip-subnet"
}

variable "subnet_cidr" {
  description = "CIDR range for the subnet"
  type        = string
  default     = "10.0.3.0/24"
}

# Static IP configuration
variable "static_ip_name" {
  description = "Name of the reserved static IP address"
  type        = string
  default     = "demo-reserved-ip"
}

# Common tags for all resources
variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    environment = "demo"
    project     = "static-ip-reservation"
    managed_by  = "terraform"
    region      = "jakarta"
    purpose     = "poc"
  }
}

# Service configuration
variable "service_port" {
  description = "Port for the IP info service"
  type        = number
  default     = 8080
}