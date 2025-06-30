# OpenTofu Infrastructure Examples

A collection of OpenTofu (Terraform) infrastructure-as-code examples designed for integration with Itential Automation Gateway (IAG), complete with input validation decorators.

## 🎯 Purpose

This repository provides simple, production-ready OpenTofu configurations that can be executed through IAG for automated infrastructure provisioning and management, with comprehensive input validation and user-friendly forms.

## ✨ Features

- **Multi-Cloud Support**: Examples for AWS, Azure, GCP
- **Modular Design**: Reusable infrastructure components
- **IAG Integration**: Optimized for Itential Automation Gateway
- **Input Validation**: JSON Schema decorators for parameter validation
- **User-Friendly Forms**: Enhanced IAG UI experience
- **Variable Management**: Flexible configuration through variables
- **State Management**: Remote state configuration examples
- **Security Best Practices**: Secure resource provisioning
- **Cost Management**: Budget controls and auto-shutdown features

## 📁 Repository Structure

```
├── README.md
├── decorators/                   # IAG input validation schemas
│   ├── opentofu-infrastructure-decorator.json
│   └── README.md
├── aws/
│   ├── simple-ec2/              # Basic EC2 instance provisioning
│   │   ├── main.tf              # Infrastructure definition
│   │   ├── variables.tf         # Configuration variables
│   │   ├── outputs.tf           # Resource outputs
│   │   ├── terraform.tfvars.example
│   │   └── README.md
│   ├── vpc-setup/               # VPC with subnets and security groups
│   └── s3-bucket/               # S3 bucket with policies
├── azure/
│   ├── linux-vm/                # Azure Linux VM with networking
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── cloud-init.yaml
│   │   └── README.md
│   ├── resource-group/          # Azure Resource Group creation
│   └── storage-account/         # Azure Storage Account
├── gcp/
│   ├── compute-instance/        # GCP Compute Engine instance
│   ├── vpc-network/             # GCP VPC network setup
│   └── storage-bucket/          # GCP Cloud Storage bucket
├── modules/
│   ├── networking/              # Reusable networking components
│   ├── security/                # Security group templates
│   └── compute/                 # Compute resource templates
└── examples/
    ├── multi-tier-app/          # Complete application stack
    ├── development-env/         # Development environment
    └── production-env/          # Production environment
```

## 🚀 Quick Start

### Prerequisites
- OpenTofu 1.6+ installed
- Cloud provider CLI tools configured (AWS CLI, Azure CLI, gcloud)
- Appropriate cloud provider credentials
- Itential Automation Gateway (for IAG integration)

### Local Usage

1. **Clone the repository:**
   ```bash
   git clone https://github.com/keepithuman/opentofu-infrastructure-examples.git
   cd opentofu-infrastructure-examples
   ```

2. **Navigate to an example:**
   ```bash
   cd aws/simple-ec2
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

### IAG Integration with Decorators

This repository is designed to work with Itential Automation Gateway with enhanced input validation:

1. **Create IAG Repository:**
   ```bash
   iagctl create repository opentofu-infra-repo \
     --description "OpenTofu Infrastructure Examples" \
     --url "https://github.com/keepithuman/opentofu-infrastructure-examples.git" \
     --reference main
   ```

2. **Create Input Validation Decorator:**
   ```bash
   iagctl create decorator opentofu-infra-decorator \
     --description "OpenTofu Infrastructure Input Validator" \
     --schema-file decorators/opentofu-infrastructure-decorator.json
   ```

3. **Create Validated IAG Service:**
   ```bash
   iagctl create service opentofu-plan aws-ec2-validated \
     --repository opentofu-infra-repo \
     --working-dir aws/simple-ec2 \
     --decorator opentofu-infra-decorator \
     --description "Validated AWS EC2 deployment with input forms"
   ```

4. **Execute via IAG with User-Friendly Forms:**
   ```bash
   iagctl run service opentofu-plan aws-ec2-validated
   ```
   
   This will present a form-based interface with:
   - Parameter validation
   - Field descriptions and examples
   - Error prevention
   - Logical field grouping

## 🎨 Input Validation Features

### Form-Based Parameter Entry
The decorator provides organized form sections:
- **Infrastructure Config**: Cloud provider, region, environment
- **Compute Config**: Instance types, storage, monitoring
- **Network Config**: Public IPs, security settings
- **Security Config**: Encryption, SSH keys, backups
- **Cost Management**: Budget alerts, auto-shutdown
- **Deployment Options**: Dry-run, auto-approval, notifications

### Validation Rules
- **Project Names**: Must be 3-20 characters, lowercase with hyphens
- **Instance Counts**: 1-10 instances maximum
- **Storage Size**: 8-1000 GB range
- **Budget Thresholds**: $10-$10,000 range
- **CIDR Blocks**: Valid IPv4 CIDR notation
- **Time Formats**: 24-hour format for schedules

### Error Prevention
- Real-time validation feedback
- Required field enforcement
- Pattern matching for naming conventions
- Range validation for numeric values
- Enum validation for cloud providers and environments

## 📋 Available Examples

### AWS Examples
- **simple-ec2**: Basic EC2 instance with security group and web server
- **vpc-setup**: Complete VPC with public/private subnets
- **s3-bucket**: S3 bucket with versioning and encryption

### Azure Examples
- **linux-vm**: Ubuntu VM with VNet, NSG, and Nginx web server
- **resource-group**: Azure Resource Group with tags
- **storage-account**: Storage account with blob containers

### GCP Examples
- **compute-instance**: Compute Engine VM with firewall rules
- **vpc-network**: VPC network with custom subnets
- **storage-bucket**: Cloud Storage bucket with IAM policies

## 🔧 Configuration Variables

### Infrastructure Configuration (Required)
```json
{
  "infrastructure_config": {
    "cloud_provider": "aws",      // aws, azure, gcp
    "region": "us-west-2",        // Target region
    "environment": "dev",         // dev, staging, prod
    "project_name": "my-app"      // Project identifier
  }
}
```

### Compute Configuration
```json
{
  "compute_config": {
    "instance_type": "t3.micro",  // VM size
    "instance_count": 1,          // Number of instances
    "storage_size_gb": 20,        // Disk size
    "enable_monitoring": false    // Detailed monitoring
  }
}
```

### Security & Cost Management
```json
{
  "security_config": {
    "encrypt_storage": true,      // Enable encryption
    "ssh_key_name": "my-key"      // SSH access key
  },
  "cost_management": {
    "cost_center": "Engineering", // Billing allocation
    "budget_alert_threshold": 100,// Monthly budget
    "auto_shutdown": {
      "enabled": true,
      "shutdown_time": "18:00"    // Daily shutdown
    }
  }
}
```

## 🔐 Security Considerations

### Credentials Management
- Use cloud provider credential files or IAM roles
- Never commit secrets to version control
- Use environment variables for sensitive data
- Consider using HashiCorp Vault integration

### Resource Security
- Security groups with least privilege access
- Encrypted storage by default
- VPC isolation for network security
- Regular security group auditing

### Validation Security
- Input sanitization through JSON Schema
- Pattern validation for resource names
- CIDR block validation for network access
- Enum validation for critical parameters

## 🏷️ Tagging Strategy

All resources are tagged with:
- `Environment`: dev/staging/prod
- `Project`: Project name from decorator
- `ManagedBy`: OpenTofu
- `Owner`: Team or individual responsible
- `CostCenter`: For cost allocation (from decorator)

## 📊 State Management

### Local State (Development)
```hcl
terraform {
  backend "local" {}
}
```

### Remote State (Production)
```hcl
terraform {
  backend "s3" {
    bucket = "my-terraform-state"
    key    = "infrastructure/terraform.tfstate"
    region = "us-west-2"
    encrypt = true
  }
}
```

## 🔄 CI/CD Integration

### GitHub Actions Example
```yaml
name: OpenTofu Plan
on:
  pull_request:
    paths:
      - '**/*.tf'
      - '**/*.tfvars'
      - 'decorators/*.json'

jobs:
  plan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: opentofu/setup-opentofu@v1
      - run: tofu init
      - run: tofu plan
```

### IAG Automation
- Use IAG scheduling for regular infrastructure updates
- Implement approval workflows for production changes
- Monitor resource drift and compliance
- Automated validation through decorators

## 🎛️ Customization

### Adding New Examples
1. Create new directory under appropriate cloud provider
2. Follow the naming convention: `purpose-description`
3. Include `main.tf`, `variables.tf`, `outputs.tf`
4. Add example `terraform.tfvars.example`
5. Update decorator schema if new parameters needed
6. Update this README with description

### Extending Decorators
1. Edit `decorators/opentofu-infrastructure-decorator.json`
2. Add new properties with validation rules
3. Update IAG decorator: `iagctl update decorator`
4. Test with example configurations

## 🔍 Troubleshooting

### Common Issues

1. **Authentication Errors**
   ```bash
   # AWS
   aws configure
   
   # Azure
   az login
   
   # GCP
   gcloud auth application-default login
   ```

2. **Decorator Validation Failures**
   - Check JSON Schema syntax
   - Verify parameter names match Terraform variables
   - Ensure required fields are provided
   - Validate example configurations

3. **State Locking Issues**
   ```bash
   # Force unlock (use with caution)
   tofu force-unlock LOCK_ID
   ```

## 💰 Cost Management Features

### Budget Controls
- Set monthly spending alerts through decorator
- Auto-shutdown scheduling for development resources
- Cost center allocation for billing
- Instance count limits to prevent over-provisioning

### Cost Optimization
- Default to cost-effective instance types
- Enable auto-shutdown for non-production environments
- Encrypted storage with lifecycle policies
- Monitoring integration for resource optimization

## 📝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-example`)
3. Follow the existing structure and naming conventions
4. Add comprehensive documentation
5. Update decorator schemas as needed
6. Test the configuration locally and through IAG
7. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Support

- **Issues**: [GitHub Issues](https://github.com/keepithuman/opentofu-infrastructure-examples/issues)
- **Discussions**: [GitHub Discussions](https://github.com/keepithuman/opentofu-infrastructure-examples/discussions)
- **Documentation**: This README and inline code comments

## 🎉 Acknowledgments

- Built for the OpenTofu community
- Designed for enterprise infrastructure automation
- Optimized for Itential Automation Gateway integration
- Enhanced with comprehensive input validation
- Inspired by infrastructure-as-code best practices

---

**Made with ❤️ for reliable, validated infrastructure automation**