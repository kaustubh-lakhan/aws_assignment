output "alb_sg_id" {
  description = "ID of the ALB Security Group"
  value       = aws_security_group.alb_sg.id
}

output "ecs_sg_id" {
  description = "ID of the ECS Service Security Group"
  value       = aws_security_group.ecs_sg.id
}

output "db_sg_id" {
  description = "ID of the Database Security Group"
  value       = aws_security_group.db_sg.id
}