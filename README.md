# OpenTofu Infrastructure Examples

A collection of OpenTofu (Terraform) infrastructure-as-code examples designed for integration with Itential Automation Gateway (IAG).

## 🎯 Purpose

This repository provides simple, production-ready OpenTofu configurations that can be executed through IAG for automated infrastructure provisioning and management.

## ✨ Features

- **Multi-Cloud Support**: Examples for AWS, Azure, GCP
- **Modular Design**: Reusable infrastructure components
- **IAG Integration**: Optimized for Itential Automation Gateway
- **Variable Management**: Flexible configuration through variables
- **State Management**: Remote state configuration examples
- **Security Best Practices**: Secure resource provisioning

## 📁 Repository Structure

```
├── README.md
├── aws/
│   ├── simple-ec2/           # Basic EC2 instance provisioning
│   ├── vpc-setup/            # VPC with subnets and security groups
│   └── s3-bucket/            # S3 bucket with policies
├── azure/
│   ├── resource-group/       # Azure Resource Group creation
│   ├── virtual-machine/      # Azure VM provisioning
│   └── storage-account/      # Azure Storage Account
├── gcp/
│   ├── compute-instance/     # GCP Compute Engine instance
│   ├── vpc-network/          # GCP VPC network setup
│   └── storage-bucket/       # GCP Cloud Storage bucket
├── modules/
│   ├── networking/           # Reusable networking components
│   ├── security/             # Security group templates
│   └── compute/              # Compute resource templates
└── examples/
    ├── multi-tier-app/       # Complete application stack
    ├── development-env/      # Development environment
    └── production-env/       # Production environment
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

### IAG Integration

This repository is designed to work with Itential Automation Gateway:

1. **Create IAG Repository:**
   ```bash
   iagctl create repository opentofu-infra-repo \
     --description "OpenTofu Infrastructure Examples" \
     --url "https://github.com/keepithuman/opentofu-infrastructure-examples.git" \
     --reference main
   ```

2. **Create IAG Service:**
   ```bash
   iagctl create service opentofu-plan simple-ec2-provision \
     --repository opentofu-infra-repo \
     --working-dir aws/simple-ec2 \
     --description "Provision simple EC2 instance" \
     --vars "instance_type=t3.micro" \
     --vars "region=us-west-2"
   ```

3. **Execute via IAG:**
   ```bash
   iagctl run service opentofu-plan simple-ec2-provision
   ```

## 📋 Available Examples

### AWS Examples
- **simple-ec2**: Basic EC2 instance with security group
- **vpc-setup**: Complete VPC with public/private subnets
- **s3-bucket**: S3 bucket with versioning and encryption

### Azure Examples
- **resource-group**: Azure Resource Group with tags
- **virtual-machine**: Linux VM with network security group
- **storage-account**: Storage account with blob containers

### GCP Examples
- **compute-instance**: Compute Engine VM with firewall rules
- **vpc-network**: VPC network with custom subnets
- **storage-bucket**: Cloud Storage bucket with IAM policies

## 🔧 Configuration Variables

Each example supports configuration through variables:

### Global Variables
- `environment`: Environment name (dev, staging, prod)
- `project_name`: Project identifier for resource naming
- `region`: Cloud provider region
- `tags`: Common tags for all resources

### Example-Specific Variables
- `instance_type`: VM/instance size
- `disk_size`: Storage disk size in GB
- `network_cidr`: Network CIDR block
- `allowed_ips`: List of allowed IP addresses

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

## 🏷️ Tagging Strategy

All resources are tagged with:
- `Environment`: dev/staging/prod
- `Project`: Project name
- `ManagedBy`: OpenTofu
- `Owner`: Team or individual responsible
- `CostCenter`: For cost allocation

## 📊 State Management

### Local State (Development)
```hcl
# Default for local development
terraform {
  backend "local" {}
}
```

### Remote State (Production)
```hcl
# S3 backend example
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

## 🎛️ Customization

### Adding New Examples
1. Create new directory under appropriate cloud provider
2. Follow the naming convention: `purpose-description`
3. Include `main.tf`, `variables.tf`, `outputs.tf`
4. Add example `terraform.tfvars.example`
5. Update this README with description

### Module Development
1. Create reusable modules in `modules/` directory
2. Document module inputs and outputs
3. Include usage examples
4. Version modules for stability

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

2. **State Locking Issues**
   ```bash
   # Force unlock (use with caution)
   tofu force-unlock LOCK_ID
   ```

3. **Provider Version Conflicts**
   ```bash
   # Upgrade providers
   tofu init -upgrade
   ```

## 📝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-example`)
3. Follow the existing structure and naming conventions
4. Add comprehensive documentation
5. Test the configuration locally
6. Submit a pull request

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
- Inspired by infrastructure-as-code best practices

---

**Made with ❤️ for reliable infrastructure automation**