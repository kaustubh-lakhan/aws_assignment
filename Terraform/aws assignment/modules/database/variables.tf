variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of Private Subnet IDs for the DB Subnet Group"
  type        = list(string)
}

variable "db_security_group_id" {
  description = "The Security Group ID for the Database"
  type        = string
}

variable "db_name" {
  description = "Name of the database to create"
  type        = string
}

variable "db_username" {
  description = "Database master username"
  type        = string
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true # Hides this from CLI output
}