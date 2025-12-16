resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled" # Enable detailed metrics
  }

  tags = {
    Name = "${var.project_name}-cluster"
  }
}

locals {
  # Define the container definition for WordPress
  wordpress_container_def = [
    {
      name      = "wordpress-app"
      image     = "wordpress:latest" # Standard WordPress image
      cpu       = 0
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
      # Pass database connection details securely via Secrets Manager
      secrets = [
        {
          name      = "WORDPRESS_DB_HOST"
          valueFrom = "${var.db_secret_arn}:db_host::"
        },
        {
          name      = "WORDPRESS_DB_NAME"
          valueFrom = "${var.db_secret_arn}:db_name::"
        },
        {
          name      = "WORDPRESS_DB_USER"
          valueFrom = "${var.db_secret_arn}:db_username::"
        },
        {
          name      = "WORDPRESS_DB_PASSWORD"
          valueFrom = "${var.db_secret_arn}:db_password::"
        }
      ]
    }
  ]
}

resource "aws_ecs_task_definition" "wordpress" {
  family                   = "${var.project_name}-wordpress-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024       # 1 vCPU
  memory                   = 2048       # 2 GB RAM
  execution_role_arn       = var.task_execution_role_arn
  container_definitions    = jsonencode(local.wordpress_container_def)

  tags = {
    Name = "WordpressTask"
  }
}

locals {
  microservice_container_def = [
    {
      name      = "microservice-app"
      image     = "${var.ecr_repository_url}:latest" # Assumed ECR repo URL input
      cpu       = 0
      memory    = 256
      essential = true
      portMappings = [
        {
          containerPort = 3000 # Running on port 3000 as requested
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]
    }
  ]
}

resource "aws_ecs_task_definition" "microservice" {
  family                   = "${var.project_name}-microservice-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512       # 0.5 vCPU
  memory                   = 1024      # 1 GB RAM
  execution_role_arn       = var.task_execution_role_arn
  container_definitions    = jsonencode(local.microservice_container_def)

  tags = {
    Name = "MicroserviceTask"
  }
}

resource "aws_ecs_service" "wordpress" {
  name            = "${var.project_name}-wordpress-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.wordpress.arn
  desired_count   = 2 # High Availability deployment across two AZs
  launch_type     = "FARGATE"
  
  # Configure Networking (Must be private subnets)
  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [var.ecs_sg_id] # Only inbound from ALB is allowed
    assign_public_ip = false
  }

  # Configure Load Balancing
  load_balancer {
    target_group_arn = var.wordpress_tg_arn
    container_name   = "wordpress-app"
    container_port   = 80
  }

  # Enable deployment circuit breaker for stability
  deployment_controller {
    type = "ECS"
  }

  tags = {
    Name = "WordpressService"
  }
}

# -----------------------------------------------------------------------------
resource "aws_ecs_service" "microservice" {
  name            = "${var.project_name}-microservice-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.microservice.arn
  desired_count   = 1 # Simple deployment
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [var.ecs_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.microservice_tg_arn
    container_name   = "microservice-app"
    container_port   = 3000
  }

  deployment_controller {
    type = "ECS"
  }

  tags = {
    Name = "MicroserviceService"
  }
}