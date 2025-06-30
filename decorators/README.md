# OpenTofu IAG Decorators

This directory contains JSON Schema decorators for Itential Automation Gateway (IAG) services. Decorators provide input validation, parameter documentation, and user-friendly forms for OpenTofu infrastructure deployments.

## 🎯 Purpose

Decorators enhance IAG services by:
- **Input Validation**: Ensure parameters meet requirements before execution
- **User Experience**: Provide intuitive forms and descriptions in IAG UI
- **Documentation**: Self-documenting service parameters and constraints
- **Error Prevention**: Catch configuration issues before deployment
- **Standardization**: Enforce consistent naming and tagging conventions

## 📁 Available Decorators

### `opentofu-infrastructure-decorator.json`
Comprehensive decorator for OpenTofu infrastructure deployment services.

**Supported Configurations:**
- **Infrastructure**: Cloud provider, region, environment, project naming
- **Compute**: Instance types, scaling, storage, monitoring
- **Networking**: Public IPs, security groups, HTTPS configuration
- **Security**: Encryption, SSH keys, backup policies
- **Cost Management**: Budget alerts, auto-shutdown, cost allocation
- **Deployment**: Dry-run mode, auto-approval, notifications

## 🚀 Using Decorators in IAG

### 1. Create Decorator in IAG
```bash
# Upload the decorator schema to IAG
iagctl create decorator opentofu-infra-decorator \
  --description "OpenTofu Infrastructure Deployment Validator" \
  --schema-file decorators/opentofu-infrastructure-decorator.json
```

### 2. Create Service with Decorator
```bash
# Create service with input validation
iagctl create service opentofu-plan aws-ec2-web-server-validated \
  --repository opentofu-infra-repo \
  --working-dir aws/simple-ec2 \
  --decorator opentofu-infra-decorator \
  --description "Validated AWS EC2 deployment with input forms"
```

### 3. Execute with Validation
When you run the service, IAG will:
- Present a user-friendly form based on the schema
- Validate all inputs against constraints
- Provide helpful error messages for invalid values
- Convert form data to OpenTofu variables

## 📋 Schema Structure

### Infrastructure Configuration (Required)
```json
{
  "infrastructure_config": {
    "cloud_provider": "aws",     // aws, azure, gcp
    "region": "us-west-2",       // Cloud provider region
    "environment": "dev",        // dev, staging, prod
    "project_name": "my-app"     // 3-20 chars, lowercase with hyphens
  }
}
```

### Compute Configuration
```json
{
  "compute_config": {
    "instance_type": "t3.micro",     // Instance size
    "instance_count": 1,             // 1-10 instances
    "storage_size_gb": 20,           // 8-1000 GB
    "enable_monitoring": false       // Enable detailed monitoring
  }
}
```

### Network Configuration
```json
{
  "network_config": {
    "create_public_ip": true,        // Assign public IP
    "allowed_ssh_cidrs": [           // SSH access ranges
      "10.0.0.0/8"
    ],
    "enable_https": false            // Configure HTTPS
  }
}
```

### Security Configuration
```json
{
  "security_config": {
    "encrypt_storage": true,         // Enable encryption
    "ssh_key_name": "my-key",        // SSH key pair name
    "backup_enabled": false          // Enable backups
  }
}
```

### Cost Management
```json
{
  "cost_management": {
    "cost_center": "Engineering",    // Billing allocation
    "budget_alert_threshold": 100,   // Monthly budget ($)
    "auto_shutdown": {
      "enabled": true,
      "shutdown_time": "18:00",      // 24-hour format
      "timezone": "UTC"
    }
  }
}
```

### Deployment Options
```json
{
  "deployment_options": {
    "dry_run": false,                // Plan-only mode
    "auto_approve": false,           // Auto-apply changes
    "parallelism": 10,               // Parallel operations
    "notification_webhook": "https://hooks.slack.com/..."
  }
}
```

## ✅ Validation Features

### Pattern Validation
- **Project Name**: `^[a-z0-9-]+$` (lowercase, numbers, hyphens only)
- **SSH CIDRs**: Valid IPv4 CIDR notation
- **Time Format**: `HH:MM` for shutdown schedules
- **URLs**: Valid webhook URLs

### Range Validation
- **Instance Count**: 1-10 instances
- **Storage Size**: 8-1000 GB
- **Budget Threshold**: $10-$10,000
- **Parallelism**: 1-20 operations

### Enum Validation
- **Cloud Provider**: aws, azure, gcp
- **Environment**: dev, staging, prod
- **Regions**: Validated against cloud provider regions

## 🎨 UI Enhancement

When using decorators, IAG provides:
- **Grouped Fields**: Logical organization of related parameters
- **Help Text**: Descriptions and examples for each field
- **Validation Messages**: Real-time feedback on invalid inputs
- **Default Values**: Sensible defaults to speed deployment
- **Conditional Fields**: Show/hide fields based on selections

## 🧪 Testing Decorator

### Valid Example
```json
{
  "infrastructure_config": {
    "cloud_provider": "aws",
    "region": "us-west-2",
    "environment": "dev",
    "project_name": "test-app"
  },
  "compute_config": {
    "instance_type": "t3.micro",
    "storage_size_gb": 20
  }
}
```

### Invalid Examples
```json
// Invalid project name (uppercase)
{
  "infrastructure_config": {
    "project_name": "TEST-APP"  // ❌ Must be lowercase
  }
}

// Invalid instance count
{
  "compute_config": {
    "instance_count": 15        // ❌ Maximum is 10
  }
}

// Invalid CIDR format
{
  "network_config": {
    "allowed_ssh_cidrs": ["not-a-cidr"]  // ❌ Invalid format
  }
}
```

## 🔧 Customizing Decorators

### Adding New Fields
1. Edit the JSON schema file
2. Add the new property with validation rules
3. Update the IAG decorator
4. Test with the service

### Environment-Specific Validation
```json
{
  "if": {
    "properties": {
      "infrastructure_config": {
        "properties": {
          "environment": { "const": "prod" }
        }
      }
    }
  },
  "then": {
    "properties": {
      "security_config": {
        "properties": {
          "encrypt_storage": { "const": true }
        },
        "required": ["encrypt_storage"]
      }
    }
  }
}
```

## 📊 Benefits

### For Users
- **Guided Input**: Form-based parameter entry
- **Error Prevention**: Catch mistakes before deployment
- **Documentation**: Built-in help and examples
- **Consistency**: Standardized configurations

### For Operations
- **Compliance**: Enforce security and naming standards
- **Cost Control**: Budget limits and auto-shutdown
- **Auditability**: Validated parameter logging
- **Scalability**: Reusable validation across teams

## 🚨 Best Practices

1. **Start Simple**: Begin with required fields, add complexity gradually
2. **Provide Examples**: Include realistic example values
3. **Clear Descriptions**: Write helpful field descriptions
4. **Test Thoroughly**: Validate schema with real deployments
5. **Version Control**: Track schema changes with your infrastructure code
6. **Environment-Specific**: Create different schemas for different environments

This decorator system ensures reliable, validated infrastructure deployments through IAG while providing an excellent user experience!