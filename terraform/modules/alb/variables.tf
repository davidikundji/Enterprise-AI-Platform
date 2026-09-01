variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "IDs of the public subnets where the ALB will be deployed"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "ID of the ALB security group"
  type        = string
}

variable "container_port" {
  description = "Port used by the application container"
  type        = number
}

variable "health_check_path" {
  description = "Application endpoint used by the ALB health check"
  type        = string
}