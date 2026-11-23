terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    gandi = {
      source  = "go-gandi/gandi"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

# CloudFront and ACM certificates require us-east-1
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

provider "gandi" {
  # Uses GANDI_PERSONAL_ACCESS_TOKEN environment variable
}
