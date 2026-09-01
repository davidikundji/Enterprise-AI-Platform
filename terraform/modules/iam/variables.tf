variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "aws_region" {
  description = "AWS region used for the Bedrock inference request"
  type        = string
}

variable "bedrock_inference_profile_id" {
  description = "Bedrock cross-region inference profile ID"
  type        = string
}

variable "bedrock_model_id" {
  description = "Underlying Bedrock foundation model ID"
  type        = string
}

variable "bedrock_destination_regions" {
  description = "AWS regions included in the Bedrock inference profile"
  type        = list(string)
}