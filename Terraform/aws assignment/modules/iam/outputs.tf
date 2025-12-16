output "ecs_task_execution_role_arn" {
  description = "The ARN of the ECS Task Execution IAM Role."
  # This value comes from the resource defined in modules/iam/main.tf
  value       = aws_iam_role.ecs_task_execution_role.arn 
}