terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
}

# タグの共通設定
locals {
  common_tags = {
    Environment = var.environment
    Project     = "mokonyan"
    ManagedBy   = "terraform"
  }
}
