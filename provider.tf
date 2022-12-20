terraform {
  cloud {
    organization = "tfclouddemo-takai"

    workspaces {
      name = "wordpress-on-aws-level2"
    }
  }

  required_version = ">=0.13"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region     = "ap-northeast-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}
