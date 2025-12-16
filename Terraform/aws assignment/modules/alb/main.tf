data "aws_acm_certificate" "site_cert" {
  domain = var.domain_name == "lakhan.click" ? "*.lakhan.click" : "*.${var.domain_name}"
  statuses = ["ISSUED"]
}

# Target Group for Wordpress
resource "aws_lb_target_group" "wordpress_tg" {
  name        = "wordpress-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    matcher             = "200,302"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_target_group" "microservice_tg" {
  name        = "microservice-tg"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path    = "/health"
    matcher = "200"
  }
}

resource "aws_lb" "ecs_alb" {
  name               = "ecs-routing-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids
  enable_deletion_protection = false

  tags = {
    Name = "${var.project_name}-ECS-ALB"
  }
}

resource "aws_lb_listener" "http_redirect" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

#testing the git update
resource "aws_lb_listener" "https_main" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = "arn:aws:acm:us-east-1:546454332581:certificate/4246b474-cbd6-4513-a2be-15d4268bd13f"
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404 Not Found - Host Header did not match a rule."
      status_code  = "404"
    }
  }
}


# Rule A: Route traffic for wordpress.yourdomain.com
resource "aws_lb_listener_rule" "wordpress_rule" {
  listener_arn = aws_lb_listener.https_main.arn
  priority     = 10

  action {
    type            = "forward"
    target_group_arn = aws_lb_target_group.wordpress_tg.arn
  }

  condition {
    host_header {
      values = ["wordpress.${var.domain_name}"]
    }
  }
}
resource "aws_lb_listener_rule" "microservice_rule" {
  listener_arn = aws_lb_listener.https_main.arn
  priority     = 20

  action {
    type            = "forward"
    target_group_arn = aws_lb_target_group.microservice_tg.arn
  }

  condition {
    host_header {
      values = ["microservice.${var.domain_name}"]
    }
  }
}