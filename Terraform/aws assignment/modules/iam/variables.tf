variable "project_name" {
  description = "Project name prefix used for naming IAM resources"
  type        = string
}

variable "secret_arn" {
  description = "The ARN of the Secrets Manager secret containing the DB credentials."
  type        = string
}