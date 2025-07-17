# Configure the Google Cloud Provider
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

# Provider configuration
provider "google" {
  project     = var.project_id
  region      = var.region
  zone        = var.zone
  credentials = file(var.credentials_path)
}