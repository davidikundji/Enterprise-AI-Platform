provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "caterpillar-ai-devops-platform"
      ManagedBy   = "Terraform"
      Environment = var.environment
    }
  }
}