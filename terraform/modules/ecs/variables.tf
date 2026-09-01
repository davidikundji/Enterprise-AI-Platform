variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "aws_region" {
  description = "AWS region where the ECS service is deployed"
  type        = string
}

variable "repository_url" {
  description = "URL of the ECR repository containing the application image"
  type        = string
}

variable "image_tag" {
  description = "Docker image tag deployed by ECS"
  type        = string
}

variable "container_port" {
  description = "Port exposed by the FastAPI container"
  type        = number
}

variable "desired_count" {
  description = "Desired number of ECS tasks"
  type        = number
}

variable "private_subnet_ids" {
  description = "Private subnet IDs used by ECS tasks"
  type        = list(string)
}

variable "ecs_security_group_id" {
  description = "Security group attached to ECS tasks"
  type        = string
}

variable "target_group_arn" {
  description = "ARN of the ALB target group"
  type        = string
}

variable "execution_role_arn" {
  description = "ARN of the ECS task execution role"
  type        = string
}

variable "task_role_arn" {
  description = "ARN of the ECS application task role"
  type        = string
}

variable "bedrock_inference_profile_id" {
  description = "Bedrock inference profile used by the application"
  type        = string
}