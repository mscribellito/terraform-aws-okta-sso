terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.66.1"
    }
    okta = {
      source  = "okta/okta"
      version = "4.0.0"
    }
  }
}