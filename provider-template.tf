# Shared Provider Configuration Template
# 
# To use this in your Terraform modules:
# 1. Copy this file to your module directory
# 2. Update the credentials path to point to the root directory
# 3. Optionally create variables for project, region, and zone
#
# Example usage:

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  credentials = file("~/Downloads/learn-gcp-465712-b4619fb17de4.json")
  project     = "learn-gcp-465712"
  region      = "asia-southeast2"
  zone        = "asia-southeast2-a"
}

# Or with variables:
# variable "project_id" {
#   default = "learn-gcp-465712"
# }
# 
# variable "region" {
#   default = "asia-southeast2"
# }
# 
# variable "zone" {
#   default = "asia-southeast2-a"
# }
# 
# provider "google" {
#   credentials = file("~/Downloads/learn-gcp-465712-b4619fb17de4.json")
#   project     = var.project_id
#   region      = var.region
#   zone        = var.zone
# }