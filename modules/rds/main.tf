# Security group of the db
resource "aws_security_group" "mariadb-sg" {
  vpc_id            = var.vpc_id
  name              = "${var.prefix_name}-sg-database"
  description       = "security group for the database"
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = var.webserver_sg_id
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }
  tags = {
    Name = "${var.prefix_name}-sg-database"
  }
}

# Subnets of the db
resource "aws_db_subnet_group" "mariadb-subnet" {
  name        = "mariadb-subnet"
  description = "RDS subnet group"
  subnet_ids  = var.private_subnet_ids
}

# Parameters of the db (mariadb)
resource "aws_db_parameter_group" "mariadb-parameters" {
  name        = "mariadb-params"
  family      = "mariadb10.1"
  description = "MariaDB parameter group"

  ## Parameters example
  # parameter {
  #   name  = "max_allowed_packet"
  #   value = 16777216
  # }
}

# Db instance
resource "aws_db_instance" "mariadb" {
  allocated_storage         = var.storage_gb
  engine                    = "mariadb"
  engine_version            = var.mariadb_version
  instance_class            = var.mariadb_instance_type
  identifier                = "mariadb"
  name                      = var.db_name
  username                  = var.db_username
  password                  = var.db_password
  db_subnet_group_name      = aws_db_subnet_group.mariadb-subnet.name
  parameter_group_name      = aws_db_parameter_group.mariadb-parameters.name
  multi_az                  = var.is_multi_az
  vpc_security_group_ids    = [aws_security_group.mariadb-sg.id]
  storage_type              = var.storage_type
  backup_retention_period   = var.backup_retention_period
  final_snapshot_identifier = "${var.prefix_name}-mariadb-snapshot" # final snapshot when executing terraform destroy
  tags = {
    Name = "${var.prefix_name}-mariadb"
  }
}
