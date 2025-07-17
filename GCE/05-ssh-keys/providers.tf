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
  
  # Using service account credentials from environment
  credentials = file("~/Downloads/learn-gcp-465712-b4619fb17de4.json")
}