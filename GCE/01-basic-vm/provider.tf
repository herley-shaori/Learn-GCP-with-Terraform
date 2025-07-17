# This file contains the Terraform configuration and provider setup
# It defines the minimum Terraform version and configures the Google Cloud provider

# Terraform block defines the Terraform configuration
terraform {
  # Specify the minimum Terraform version required
  # This ensures compatibility and prevents issues with older versions
  required_version = ">= 1.0"
  
  # Define required providers and their versions
  required_providers {
    # Google Cloud Platform provider
    google = {
      # Source indicates where to download the provider from
      # hashicorp/google is the official GCP provider
      source  = "hashicorp/google"
      
      # Version constraint using pessimistic operator (~>)
      # ~> 5.0 means >= 5.0.0 and < 6.0.0
      # This allows minor updates but prevents breaking changes
      version = "~> 5.0"
    }
  }
}

# Provider block configures the Google Cloud provider
# This tells Terraform how to authenticate and which project/region to use
provider "google" {
  # Authentication options:
  # 1. Set GOOGLE_APPLICATION_CREDENTIALS environment variable
  # 2. Use gcloud auth application-default login
  # 3. Specify credentials file path (not recommended for production)
  # 4. Use service account attached to the resource running Terraform
  # 
  # Uncomment and set path if using credentials file:
  # credentials = file(var.credentials_file)
  
  # GCP project ID where resources will be created
  # Using variable allows easy switching between projects
  project     = var.project_id
  
  # Default region for regional resources (e.g., Cloud Storage buckets)
  # asia-southeast2 is Jakarta region
  region      = var.region
  
  # Default zone for zonal resources (e.g., Compute Engine instances)
  # asia-southeast2-a is one of the zones in Jakarta region
  zone        = var.zone
}