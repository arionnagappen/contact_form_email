terraform {
  backend "s3" {
    bucket         = "travelease-tfstate"
    key            = "dev/terraform.tfstate"
    region         = "eu-west-1"
    use_lockfile = true
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"  
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0" 
    }
  }
}
