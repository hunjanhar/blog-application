resource "random_password" "db_password" {
  length           = 16
  special          = false
}

resource "aws_db_subnet_group" "blog-app-db-subnet-group" {
  name        = "blog-app-db-subnet-group"
  description = "Database subnet group for blog-app"
  subnet_ids  = [aws_subnet.rds_private_subnet_a.id, aws_subnet.rds_private_subnet_b.id]

  tags = { Name = "blog-app-db-subnet-group" }
}

resource "aws_security_group" "blog-app-rds-sg" {
  name        = "blog-app-rds-sg"
  description = "Controls inbound traffic to the MySQL RDS database instance"
  vpc_id      = aws_vpc.blog_app_vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    description     = "Allow MySQL traffic"
    security_groups = [aws_security_group.blog_app_security_group.id] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "blog-app-rds-sg" }
}

resource "aws_db_instance" "blog-app-mysql" {
  allocated_storage       = 20
  max_allocated_storage   = 30
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t4g.micro"
  
  db_name                 = "blogapp"
  username                = "admin"
  password                = random_password.db_password.result
  
  storage_type            = "gp3"
  multi_az                = false
  backup_retention_period = 1
  skip_final_snapshot     = true
  deletion_protection     = false
  vpc_security_group_ids  = [aws_security_group.blog-app-rds-sg.id]
  db_subnet_group_name    = aws_db_subnet_group.blog-app-db-subnet-group.name
}