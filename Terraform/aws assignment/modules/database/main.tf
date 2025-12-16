resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

# 2. RDS MySQL Instance
resource "aws_db_instance" "main" {
  identifier        = "${var.project_name}-db"
  
  # Engine Details
  engine            = "mysql"
  engine_version    = "8.0"      # Using a stable MySQL 8.0 version
  instance_class    = "db.t3.micro" # Free-tier eligible
  allocated_storage = 20         # 20 GB standard storage
  storage_type      = "gp2"

  # Database Config (As requested)
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  port     = 3306

  # Networking
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.db_security_group_id]
  publicly_accessible    = false 

  skip_final_snapshot    = true  # Skips snapshot on destroy (faster cleanup)
  multi_az               = false # Set to true if you want HA (costs more)

  tags = {
    Name = "${var.project_name}-mysql"
  }
}