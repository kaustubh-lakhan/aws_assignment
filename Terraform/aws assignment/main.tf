locals {
  db_name     = "wordpress"
  db_username = "admin"
  db_password = "adminjack"
}

module "networking" {
  source = "./modules/networking"

  vpc_cidr             = "10.0.0.0/16"
  # 2 Public Subnets
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  # 2 Private Subnets
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  
  project_name = "assignment-cloudzenia"
  environment  = "dev"
}

module "security" {
  source = "./modules/security"

  project_name = "assignment-cloudzenia"
  vpc_id       = module.networking.vpc_id 
}
 
module "database" {
  source = "./modules/database"
  project_name = "assignment-cloudzenia"
  private_subnet_ids = module.networking.private_subnet_ids
  db_security_group_id = module.security.db_sg_id
  db_name     = local.db_name
  db_username = local.db_username
  db_password = local.db_password
}

module "secrets" {
  source = "./modules/secrets"
  project_name = "assignment-cloudzenia"
  db_endpoint = module.database.db_endpoint
  db_name     = local.db_name
  db_username = local.db_username
  db_password = local.db_password
}

module "iam" {
  source = "./modules/iam"
  project_name = "assignment-cloudzenia" 
  secret_arn = module.secrets.db_secret_arn 
}

output "ecs_task_execution_role_arn" {
  value = module.iam.ecs_task_execution_role_arn
}


module "alb" {
  source = "./modules/alb"

  project_name = "assignment-cloudzenia"

  vpc_id            = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids

  alb_sg_id = module.security.alb_sg_id

  domain_name = var.domain_name
}


module "ecs" {
  source = "./modules/ecs"

  project_name = "assignment-cloudzenia"

  # IAM input
  task_execution_role_arn = module.iam.ecs_task_execution_role_arn

  # Secrets input
  db_secret_arn = module.secrets.db_secret_arn

  # Networking inputs
  private_subnet_ids = module.networking.private_subnet_ids

  # Security input
  ecs_sg_id = module.security.ecs_sg_id

  # ALB inputs
  wordpress_tg_arn    = module.alb.wordpress_tg_arn
  microservice_tg_arn = module.alb.microservice_tg_arn

  # ECR input
  ecr_repository_url = var.ecr_repository_url
}


output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "wordpress_url_hint" {
  value = "https://wordpress.${var.domain_name} (Requires DNS setup and a running ECS task)"
}

output "ecs_cluster_name" {
  value = module.ecs.ecs_cluster_id
}



output "wordpress_tg_arn" {
  value = module.alb.wordpress_tg_arn
}
