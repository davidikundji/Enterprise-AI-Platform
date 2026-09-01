variable "project_name" {
  description = "Name used to identify project resources"
  type        = string
  default     = "caterpillar-ai-devops-platform"
}

variable "aws_region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "container_port" {
  description = "Port exposed by the FastAPI container"
  type        = number
  default     = 8000
}

variable "ecs_desired_count" {
  description = "Desired number of ECS tasks"
  type        = number
  default     = 2
}

variable "ecs_min_capacity" {
  description = "Minimum number of ECS tasks for service auto scaling"
  type        = number
  default     = 2
}

variable "ecs_max_capacity" {
  description = "Maximum number of ECS tasks for service auto scaling"
  type        = number
  default     = 4
}

variable "ecs_cpu_target" {
  description = "Target average CPU utilization percentage for ECS auto scaling"
  type        = number
  default     = 60
}

variable "ecs_memory_target" {
  description = "Target average memory utilization percentage for ECS auto scaling"
  type        = number
  default     = 70
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)

  default = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)

  default = [
    "10.0.11.0/24",
    "10.0.12.0/24"
  ]
}

variable "bedrock_inference_profile_id" {
  description = "Bedrock cross-region inference profile used by the application"
  type        = string
  default     = "us.anthropic.claude-haiku-4-5-20251001-v1:0"
}

variable "bedrock_model_id" {
  description = "Underlying Bedrock foundation model used by the inference profile"
  type        = string
  default     = "anthropic.claude-haiku-4-5-20251001-v1:0"
}

variable "bedrock_destination_regions" {
  description = "AWS regions available to the Bedrock cross-region inference profile"
  type        = list(string)

  default = [
    "us-east-1",
    "us-east-2",
    "us-west-2"
  ]
}

variable "health_check_path" {
  description = "Health check endpoint used by the Application Load Balancer"
  type        = string
  default     = "/health"
}

variable "image_tag" {
  description = "Docker image tag deployed to ECS"
  type        = string
  default     = "1.0"
}

variable "cpu_alarm_threshold" {
  description = "CPU utilization percentage that triggers the operational alarm"
  type        = number
  default     = 80
}

variable "memory_alarm_threshold" {
  description = "Memory utilization percentage that triggers the operational alarm"
  type        = number
  default     = 85
}