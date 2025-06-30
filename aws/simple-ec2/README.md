# Simple EC2 Web Server

This example provisions a simple web server on AWS EC2 with Apache HTTP server, security groups, and optional Elastic IP.

## 🏗️ Architecture

- **EC2 Instance**: Amazon Linux 2 with Apache web server
- **Security Group**: Allows HTTP (80), HTTPS (443), and SSH (22) access
- **User Data**: Automatically installs and configures Apache
- **Optional**: Elastic IP for static public IP address
- **Storage**: Encrypted EBS volume

## 🚀 Quick Start

### Prerequisites
- AWS CLI configured with appropriate credentials
- OpenTofu installed (version 1.0+)
- AWS account with permissions to create EC2 instances, security groups, and EIPs

### Local Deployment

1. **Clone and navigate:**
   ```bash
   cd aws/simple-ec2
   ```

2. **Copy and customize variables:**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your values
   ```

3. **Initialize OpenTofu:**
   ```bash
   tofu init
   ```

4. **Plan the deployment:**
   ```bash
   tofu plan
   ```

5. **Apply the configuration:**
   ```bash
   tofu apply
   ```

6. **Access your web server:**
   ```bash
   # Get the public IP from outputs
   tofu output instance_public_ip
   
   # Visit in browser
   open http://$(tofu output -raw instance_public_ip)
   ```

### IAG Deployment

This example is optimized for Itential Automation Gateway:

```bash
# Create IAG repository (if not already created)
iagctl create repository opentofu-infra-repo \
  --description "OpenTofu Infrastructure Examples" \
  --url "https://github.com/keepithuman/opentofu-infrastructure-examples.git" \
  --reference main

# Create IAG service
iagctl create service opentofu-plan simple-ec2-provision \
  --repository opentofu-infra-repo \
  --working-dir aws/simple-ec2 \
  --description "Provision simple EC2 web server" \
  --vars "instance_type=t3.micro" \
  --vars "aws_region=us-west-2" \
  --vars "project_name=iag-web-server"

# Execute via IAG
iagctl run service opentofu-plan simple-ec2-provision
```

## ⚙️ Configuration

### Required Variables
- `aws_region`: AWS region for deployment
- `project_name`: Name prefix for resources

### Optional Variables
- `instance_type`: EC2 instance size (default: t3.micro)
- `key_pair_name`: SSH key pair name for access
- `allowed_ssh_cidr`: IP ranges allowed for SSH (default: 0.0.0.0/0 - restrict this!)
- `create_elastic_ip`: Whether to create static IP (default: false)
- `root_volume_size`: EBS volume size in GB (default: 20)

### Example Configuration
```hcl
aws_region        = "us-east-1"
project_name      = "my-app"
environment       = "prod"
instance_type     = "t3.small"
key_pair_name     = "my-key-pair"
allowed_ssh_cidr  = ["203.0.113.0/24"]  # Your office IP range
create_elastic_ip = true
```

## 📊 Outputs

After deployment, you'll get:
- `instance_id`: EC2 instance identifier
- `instance_public_ip`: Public IP address
- `instance_private_ip`: Private IP address
- `security_group_id`: Security group ID
- `website_url`: Direct URL to access the web application
- `ssh_command`: SSH command to connect (if key pair specified)

## 🔐 Security Features

- **Encrypted Storage**: EBS volumes are encrypted by default
- **Security Groups**: Restrictive ingress rules
- **Latest AMI**: Uses most recent Amazon Linux 2 AMI
- **HTTPS Ready**: Security group allows HTTPS traffic

### Security Recommendations

1. **Restrict SSH Access**: 
   ```hcl
   allowed_ssh_cidr = ["YOUR_IP/32"]  # Your specific IP
   ```

2. **Use Key Pairs**:
   ```bash
   # Create key pair in AWS Console or CLI
   aws ec2 create-key-pair --key-name my-key --query 'KeyMaterial' --output text > my-key.pem
   chmod 400 my-key.pem
   ```

3. **Enable VPC Flow Logs** (for production)
4. **Use Systems Manager Session Manager** instead of SSH

## 🧪 Testing

### Verify Web Server
```bash
# Get the instance IP
INSTANCE_IP=$(tofu output -raw instance_public_ip)

# Test HTTP connectivity
curl -I http://$INSTANCE_IP

# Test in browser
open http://$INSTANCE_IP
```

### SSH Access (if key pair configured)
```bash
ssh -i ~/.ssh/your-key.pem ec2-user@$(tofu output -raw instance_public_ip)
```

## 💰 Cost Considerations

- **t3.micro**: ~$8.50/month (Free Tier: 750 hours/month free for first 12 months)
- **EBS gp3 20GB**: ~$1.60/month (Free Tier: 30GB free for first 12 months)
- **Elastic IP**: Free when attached to running instance, $3.65/month when unattached
- **Data Transfer**: First 1GB/month free, then $0.09/GB

### Cost Optimization
- Use `t3.nano` for minimal workloads
- Enable detailed monitoring only if needed
- Terminate instances when not in use
- Use Reserved Instances for long-term workloads

## 🧹 Cleanup

```bash
# Destroy all resources
tofu destroy

# Or via IAG
iagctl run service opentofu-plan simple-ec2-destroy
```

## 🔧 Customization

### Add HTTPS/SSL
```hcl
# Add to user_data in main.tf
yum install -y mod_ssl
systemctl restart httpd
```

### Custom Application
```hcl
# Replace the HTML content in user_data with your application deployment
```

### Multiple Instances
```hcl
# Add count parameter to aws_instance
resource "aws_instance" "web_server" {
  count = var.instance_count
  # ... rest of configuration
}
```

## 🚨 Troubleshooting

### Common Issues

1. **Instance not accessible**:
   - Check security group rules
   - Verify instance is in running state
   - Confirm public IP assignment

2. **SSH connection refused**:
   - Verify key pair name matches
   - Check file permissions on private key (chmod 400)
   - Ensure SSH is allowed in security group

3. **Web server not responding**:
   - Check instance logs: `aws logs describe-log-groups`
   - SSH to instance and check Apache status: `sudo systemctl status httpd`

### Debug Commands
```bash
# Check instance status
aws ec2 describe-instances --instance-ids $(tofu output -raw instance_id)

# Check security group rules
aws ec2 describe-security-groups --group-ids $(tofu output -raw security_group_id)
```

This example provides a solid foundation for web application hosting and can be extended with load balancers, auto-scaling, and database backends.