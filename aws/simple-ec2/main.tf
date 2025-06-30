# Configure the AWS Provider
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Data source to get the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Data source to get the default VPC
data "aws_vpc" "default" {
  default = true
}

# Create a security group
resource "aws_security_group" "web_sg" {
  name_prefix = "${var.project_name}-web-"
  description = "Security group for web server"
  vpc_id      = data.aws_vpc.default.id

  # SSH access
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidr
  }

  # HTTP access
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS access
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # All outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-web-sg"
  })
}

# Create EC2 instance
resource "aws_instance" "web_server" {
  ami                     = data.aws_ami.amazon_linux.id
  instance_type           = var.instance_type
  key_name               = var.key_pair_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  
  root_block_device {
    volume_type = "gp3"
    volume_size = var.root_volume_size
    encrypted   = true
    
    tags = merge(var.common_tags, {
      Name = "${var.project_name}-root-volume"
    })
  }

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    
    # Create a simple index page
    cat > /var/www/html/index.html << 'HTML'
    <!DOCTYPE html>
    <html>
    <head>
        <title>Welcome to ${var.project_name}</title>
        <style>
            body { font-family: Arial, sans-serif; margin: 40px; }
            .container { max-width: 800px; margin: 0 auto; }
            .header { background: #232f3e; color: white; padding: 20px; border-radius: 5px; }
            .content { background: #f4f4f4; padding: 20px; border-radius: 5px; margin-top: 20px; }
            .info { background: white; padding: 15px; border-radius: 5px; margin: 10px 0; }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1>🚀 Welcome to ${var.project_name}</h1>
                <p>Deployed with OpenTofu via Itential Automation Gateway</p>
            </div>
            <div class="content">
                <div class="info">
                    <h3>Instance Information</h3>
                    <p><strong>Environment:</strong> ${var.environment}</p>
                    <p><strong>Instance Type:</strong> ${var.instance_type}</p>
                    <p><strong>Region:</strong> ${var.aws_region}</p>
                    <p><strong>Deployed:</strong> $(date)</p>
                </div>
                <div class="info">
                    <h3>Server Status</h3>
                    <p>✅ Web server is running successfully!</p>
                    <p>✅ Instance provisioned via Infrastructure as Code</p>
                    <p>✅ Security groups configured</p>
                </div>
            </div>
        </div>
    </body>
    </html>
HTML
  EOF

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-web-server"
  })
}

# Create an Elastic IP (optional)
resource "aws_eip" "web_eip" {
  count    = var.create_elastic_ip ? 1 : 0
  instance = aws_instance.web_server.id
  domain   = "vpc"

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-web-eip"
  })

  depends_on = [aws_instance.web_server]
}