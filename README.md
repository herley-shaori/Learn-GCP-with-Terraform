# Learn GCP with Terraform

This repository contains Terraform configurations for learning and experimenting with Google Cloud Platform (GCP) services.

## Repository Structure

```
.
├── README.md                    # This file
├── provider-template.tf         # Template for provider configuration
├── terraform.tfvars.example     # Example variables file
├── *.json                       # GCP service account credentials (not tracked)
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

2. **Set up authentication** (choose one method):
   
   **Option 1: Environment Variable (Recommended)**
   ```bash
   export GOOGLE_APPLICATION_CREDENTIALS="/path/to/your-service-account-key.json"
   ```
   
   **Option 2: Application Default Credentials**
   ```bash
   gcloud auth application-default login
   ```
   
   **Option 3: Service Account Key File**
   - Store your GCP service account JSON key file outside the repository
   - Update the `credentials_path` variable in terraform.tfvars
   - Never commit credentials to git

3. **Create terraform.tfvars**:
   ```hcl
   # Copy from terraform.tfvars.example
   project_id = "your-gcp-project-id"
   ```

4. **Enable required APIs** in your GCP project:
   - Compute Engine API
   - (Additional APIs as needed for specific modules)

## Shared Configuration

This repository uses a shared configuration approach for consistency across modules:

- **Credentials**: Service account JSON file stored outside repository
- **Project ID**: Your GCP project ID
- **Default Region**: `asia-southeast2` (Jakarta)
- **Default Zone**: `asia-southeast2-a`

### Using the Provider Template

Each module uses variables for configuration:

```hcl
provider "google" {
  # Authentication handled via environment variable or gcloud
  project = var.project_id
  region  = var.region
  zone    = var.zone
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

## Security Best Practices

### Authentication Security
1. **Never commit credentials** to version control
   - Use `.gitignore` for `*.json`, `*.tfvars`, `*.tfstate`
   - Store service account keys outside the repository
   
2. **Use environment variables** for authentication:
   ```bash
   export GOOGLE_APPLICATION_CREDENTIALS="/secure/path/to/key.json"
   ```

3. **Rotate service account keys** regularly
   - Delete old keys after creating new ones
   - Use key rotation policies in production

### Terraform Security
1. **Protect state files**
   - Never commit `terraform.tfstate` files
   - Use remote state backend (GCS) for team projects
   
2. **Use variables for sensitive data**
   - Define sensitive variables without defaults
   - Pass values via `terraform.tfvars` (gitignored)
   
3. **Review before committing**
   - Check for hardcoded project IDs
   - Verify no credentials in code
   - Ensure `.gitignore` is properly configured

### GCP Security
1. **Principle of least privilege**
   - Grant minimal required permissions
   - Use custom roles when possible
   
2. **Resource isolation**
   - Use separate projects for dev/staging/prod
   - Implement VPC security controls
   
3. **Monitoring and auditing**
   - Enable Cloud Audit Logs
   - Set up billing alerts
   - Monitor for unusual activity

## Contributing

When adding new modules:
1. Create a new directory with descriptive name
2. Include a README.md with clear instructions
3. Use the shared provider configuration pattern
4. Focus on learning objectives
5. Minimize costs by using free/cheap resources

## License

This is a learning repository. Feel free to use and modify as needed for your own GCP learning journey.
