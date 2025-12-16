variable "project_name" {
  description = "Project name prefix used for naming the secret"
  type        = string
}

variable "db_endpoint" {
  description = "The connection endpoint for the RDS instance"
  type        = string
}

variable "db_name" {
  description = "The database name"
  type        = string
}

variable "db_username" {
  description = "The database master username"
  type        = string
}

variable "db_password" {
  description = "The database master password"
  type        = string
  sensitive   = true
}