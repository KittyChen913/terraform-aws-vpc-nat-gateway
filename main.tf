# EC2 Terraform 配置文件

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# 連接到 AWS 指定 region，使用指定 profile
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

# ============================================================================
# Data Sources
# ============================================================================

# 自動讀取最新的 Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# 獲取所有可用的 AZ
data "aws_availability_zones" "available" {
  state = "available"
}