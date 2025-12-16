resource "aws_secretsmanager_secret" "db_credentials" {
  name                    = "${var.project_name}/wordpress/rds/credentials"
  description             = "Wordpress RDS MySQL connection details"
  recovery_window_in_days = 0 # Set to 0 for quick cleanup in dev/test
}

locals {
  secret_string = jsonencode({
    db_host     = var.db_endpoint
    db_name     = var.db_name
    db_username = var.db_username
    db_password = var.db_password
  })
}

resource "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id     = aws_secretsmanager_secret.db_credentials.id
  secret_string = local.secret_string
}