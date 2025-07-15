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
  # Path to service account key file for authentication
  # IMPORTANT: Never commit credentials to version control
  # Consider using environment variables or other secure methods in production
  credentials = file("~/Downloads/learn-gcp-465712-b4619fb17de4.json")
  
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