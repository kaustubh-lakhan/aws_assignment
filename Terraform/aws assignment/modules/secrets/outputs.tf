output "db_secret_arn" {
  description = "The ARN of the Secrets Manager secret for the database credentials."
  value       = aws_secretsmanager_secret.db_credentials.arn
}