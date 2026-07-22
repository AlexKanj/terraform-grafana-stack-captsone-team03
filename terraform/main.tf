terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    key     = "monitoring/terraform.tfstate"
    encrypt = true
    # bucket and region passed via -backend-config during terraform init
    # e.g. terraform init -backend-config="bucket=my-tf-state" -backend-config="region=us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
}
