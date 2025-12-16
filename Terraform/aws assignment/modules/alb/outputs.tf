output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.ecs_alb.dns_name
}

output "wordpress_tg_arn" {
  description = "ARN of the Wordpress Target Group"
  value       = aws_lb_target_group.wordpress_tg.arn
}

output "microservice_tg_arn" {
  description = "ARN of the Microservice Target Group"
  value       = aws_lb_target_group.microservice_tg.arn
}