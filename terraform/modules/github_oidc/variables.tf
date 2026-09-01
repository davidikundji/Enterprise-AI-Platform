variable "github_owner" {
  description = "GitHub repository owner"
  type        = string
}

variable "github_owner_id" {
  description = "Immutable numeric ID of the GitHub repository owner"
  type        = string
}

variable "github_repository" {
  description = "GitHub repository name"
  type        = string
}

variable "github_repository_id" {
  description = "Immutable numeric ID of the GitHub repository"
  type        = string
}

variable "github_branch" {
  description = "GitHub branch allowed to deploy"
  type        = string
  default     = "main"
}

variable "ecr_repository_arn" {
  description = "ARN of the ECR repository used by the deployment pipeline"
  type        = string
}

variable "ecs_service_arn" {
  description = "ARN of the ECS service updated by the deployment pipeline"
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