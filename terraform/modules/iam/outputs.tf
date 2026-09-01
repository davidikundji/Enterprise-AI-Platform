output "execution_role_arn" {
  description = "ARN of the ECS task execution role"
  value       = aws_iam_role.execution.arn
}

output "task_role_arn" {
  description = "ARN of the ECS application task role"
  value       = aws_iam_role.task.arn
}

output "execution_role_name" {
  description = "Name of the ECS task execution role"
  value       = aws_iam_role.execution.name
}

output "task_role_name" {
  description = "Name of the ECS application task role"
  value       = aws_iam_role.task.name
}

output "bedrock_policy_arn" {
  description = "ARN of the Bedrock invocation policy"
  value       = aws_iam_policy.bedrock.arn
}