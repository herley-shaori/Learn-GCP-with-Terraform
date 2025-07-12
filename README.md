# Learn GCP with Terraform

This repository contains Terraform configurations for learning and experimenting with Google Cloud Platform (GCP) services.

## Repository Structure

```
.
├── README.md                    # This file
├── provider-template.tf         # Template for provider configuration
├── terraform.tfvars.example     # Example variables file
├── learn-gcp-465712-*.json      # GCP service account credentials (not tracked)
├── simple-gcs/                  # Simple VM deployment example
└── [future-modules]/            # Additional GCP learning modules
```

## Getting Started

### Prerequisites

1. **Terraform**: Install Terraform (version 1.0 or later)
2. **GCP Account**: Active Google Cloud Platform account
3. **Service Account**: GCP service account with appropriate permissions
4. **gcloud CLI**: (Optional) For additional GCP management

### Initial Setup

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd Learn-GCP-with-Terraform
   ```

2. **Add your service account key**:
   - Place your GCP service account JSON key file in the root directory
   - The file should match the pattern: `learn-gcp-*.json`
   - This file is git-ignored for security

3. **Enable required APIs** in your GCP project:
   - Compute Engine API
   - (Additional APIs as needed for specific modules)

## Shared Configuration

This repository uses a shared configuration approach for consistency across modules:

- **Credentials**: Service account JSON file in the root directory
- **Project ID**: `learn-gcp-465712` (update in each module as needed)
- **Default Region**: `asia-southeast2` (Jakarta)
- **Default Zone**: `asia-southeast2-a`

### Using the Provider Template

Each module references the credentials file from the parent directory:

```hcl
provider "google" {
  credentials = file("../learn-gcp-465712-16bdad8c3ce1.json")
  project     = "learn-gcp-465712"
  region      = "asia-southeast2"
  zone        = "asia-southeast2-a"
}
```

## Available Modules

### 1. simple-gcs
A basic example demonstrating:
- Deploying an e2-micro VM (most cost-effective)
- Configuring firewall rules
- Setting up a web server
- [View Module README](./simple-gcs/README.md)

### Future Modules (Planned)
- Cloud Storage buckets
- Cloud Functions
- Cloud Run services
- VPC networking
- Load balancers
- Kubernetes Engine (GKE)

## Working with Modules

Each module is self-contained and can be deployed independently:

```bash
# Navigate to a module
cd simple-gcs/

# Initialize Terraform
terraform init

# Plan deployment
terraform plan

# Apply configuration
terraform apply

# Destroy resources (important for cost management!)
terraform destroy
```

## Best Practices

1. **Always destroy resources** when done experimenting to avoid charges
2. **Use the cheapest options** for learning (e.g., e2-micro instances)
3. **Keep credentials secure** - never commit them to git
4. **Enable only required APIs** to maintain security
5. **Use consistent naming** across all resources
6. **Tag resources appropriately** for cost tracking

## Cost Management

- Most examples use free tier or lowest-cost resources
- Always run `terraform destroy` after experiments
- Monitor your GCP billing dashboard regularly
- Set up billing alerts in GCP Console

## Security Notes

- Service account credentials are git-ignored
- Use least-privilege permissions for service accounts
- Regularly rotate service account keys
- Consider using Workload Identity for production

## Contributing

When adding new modules:
1. Create a new directory with descriptive name
2. Include a README.md with clear instructions
3. Use the shared provider configuration pattern
4. Focus on learning objectives
5. Minimize costs by using free/cheap resources

## License

This is a learning repository. Feel free to use and modify as needed for your own GCP learning journey.
