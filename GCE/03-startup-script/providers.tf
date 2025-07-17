# Configure the Google Cloud Provider
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    # Random provider for generating unique identifiers
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

# Provider configuration
provider "google" {
  project     = var.project_id
  region      = var.region
  zone        = var.zone
  
  # Authentication options:
  # 1. Set GOOGLE_APPLICATION_CREDENTIALS environment variable
  # 2. Use gcloud auth application-default login
  # 3. Specify credentials file path (not recommended for production)
  # 4. Use service account attached to the resource running Terraform
  # 
  # Uncomment and set path if using credentials file:
  # credentials = file(var.credentials_path)
}

# Random provider (no configuration needed)
provider "random" {}