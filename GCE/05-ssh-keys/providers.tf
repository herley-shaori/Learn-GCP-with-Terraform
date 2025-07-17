# Terraform configuration block
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

# Google Cloud Provider configuration
provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
  
  # Authentication options:
  # 1. Set GOOGLE_APPLICATION_CREDENTIALS environment variable
  # 2. Use gcloud auth application-default login
  # 3. Specify credentials file path (not recommended for production)
  # 4. Use service account attached to the resource running Terraform
  # 
  # Uncomment and set path if using credentials file:
  # credentials = file(var.credentials_path)
}