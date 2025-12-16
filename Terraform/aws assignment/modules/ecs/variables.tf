variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "task_execution_role_arn" {
  description = "ARN of the IAM Role for ECS Task Execution"
  type        = string
}

variable "db_secret_arn" {
  description = "ARN of the Secrets Manager secret containing DB credentials"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of Private Subnet IDs for ECS tasks"
  type        = list(string)
}

variable "ecs_sg_id" {
  description = "Security Group ID for ECS tasks"
  type        = string
}

variable "wordpress_tg_arn" {
  description = "ARN of the Wordpress Target Group"
  type        = string
}

variable "microservice_tg_arn" {
  description = "ARN of the Microservice Target Group"
  type        = string
}

variable "ecr_repository_url" {
  description = "Full URL to the ECR repository for the custom microservice image"
  type        = string
}