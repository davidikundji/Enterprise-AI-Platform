variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "service_name" {
  description = "Name of the ECS service"
  type        = string
}

variable "min_capacity" {
  description = "Minimum number of ECS tasks"
  type        = number
}

variable "max_capacity" {
  description = "Maximum number of ECS tasks"
  type        = number
}

variable "cpu_target" {
  description = "Target average CPU utilization percentage"
  type        = number
}

variable "memory_target" {
  description = "Target average memory utilization percentage"
  type        = number
}