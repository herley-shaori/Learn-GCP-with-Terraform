# SSH Keys Demo Test Plan

## Success Criteria

This demo will be considered successful if ALL of the following criteria are met:

### 1. Infrastructure Provisioning ✓
- [ ] VM instance is successfully created in Jakarta region (asia-southeast2)
- [ ] VM is accessible via external IP address
- [ ] All Terraform resources are properly tagged and labeled

### 2. SSH Key Management ✓
- [ ] SSH key pair is generated successfully
- [ ] Public key is properly deployed to VM via metadata
- [ ] Can SSH into VM using the private key without password
- [ ] SSH connection uses key-based authentication only

### 3. Startup Script Execution ✓
- [ ] Startup script runs successfully on VM boot
- [ ] Custom MOTD banner is displayed on SSH login
- [ ] System info dashboard shows correct information
- [ ] Web server is running on port 8080

### 4. Security Configuration ✓
- [ ] Firewall rules allow only SSH (22) and HTTP (8080) traffic
- [ ] VM uses minimal permissions service account
- [ ] SSH keys are properly formatted and secure

## Test Cases

### Test Case 1: VM Creation and Basic Connectivity
**Steps:**
1. Run `terraform init` to initialize the configuration
2. Run `terraform plan` to review resources
3. Run `terraform apply` to create infrastructure
4. Verify VM is created in GCP Console
5. Check VM has external IP assigned

**Expected Result:** VM is running with external IP in Jakarta region

### Test Case 2: SSH Key Authentication
**Steps:**
1. Use the SSH command from Terraform output
2. Attempt to connect: `ssh -i demo-key demo-user@<EXTERNAL_IP>`
3. Verify no password is requested
4. Check authorized_keys file on VM

**Expected Result:** Successfully connect via SSH using key authentication

### Test Case 3: Startup Script and Features
**Steps:**
1. SSH into the VM
2. Check if custom MOTD is displayed
3. Verify system info dashboard appears
4. Access web server at http://<EXTERNAL_IP>:8080
5. Check startup script logs: `sudo cat /var/log/startup-script.log`

**Expected Result:** All custom features are working correctly

### Test Case 4: Cost Optimization
**Steps:**
1. Verify VM is using e2-micro instance type
2. Check disk is pd-standard type
3. Confirm using ephemeral IP (not static)
4. Review estimated monthly cost

**Expected Result:** Configuration uses the cheapest possible options

## Scenario Testing

### Scenario 1: Key Rotation
**Purpose:** Demonstrate how to rotate SSH keys safely
**Steps:**
1. Generate new SSH key pair
2. Update Terraform configuration with new public key
3. Run `terraform apply` to update metadata
4. Test both old and new keys
5. Remove old key and apply again

### Scenario 2: Multiple User Access
**Purpose:** Show how to manage multiple SSH users
**Steps:**
1. Generate additional SSH key for second user
2. Update metadata to include multiple keys
3. Apply changes and test access for both users
4. Verify each user can only access their own home directory