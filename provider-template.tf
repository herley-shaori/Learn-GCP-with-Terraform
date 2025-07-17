# Shared Provider Configuration Template
# 
# To use this in your Terraform modules:
# 1. Copy this file to your module directory
# 2. Set up authentication using one of the methods below
# 3. Create variables for project, region, and zone
#
# Authentication options:
# - Environment variable: export GOOGLE_APPLICATION_CREDENTIALS="path/to/key.json"
# - Credentials file: credentials = file("path/to/key.json")
# - Application Default Credentials (ADC)
# - Workload Identity (for GKE)

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

# Option 1: Using variables (recommended)
variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "Default region for resources"
  type        = string
  default     = "asia-southeast2"  # Jakarta
}

variable "zone" {
  description = "Default zone for resources"
  type        = string
  default     = "asia-southeast2-a"
}

provider "google" {
  # Authentication methods (choose one):
  # 1. Use environment variable GOOGLE_APPLICATION_CREDENTIALS
  # 2. Use service account key file:
  #    credentials = file("path/to/your-service-account-key.json")
  # 3. Use Application Default Credentials (gcloud auth)
  
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# Option 2: Direct configuration (not recommended for production)
# provider "google" {
#   credentials = file("path/to/your-service-account-key.json")
#   project     = "your-project-id"
#   region      = "asia-southeast2"
#   zone        = "asia-southeast2-a"
# }

# Option 3: Using service account impersonation (recommended for production)
# provider "google" {
#   alias = "impersonated"
#   impersonate_service_account = "terraform@your-project.iam.gserviceaccount.com"
#   project = var.project_id
#   region  = var.region
#   zone    = var.zone
# }