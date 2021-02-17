
resource "aws_db_instance" "postgres" {
  allocated_storage      = var.allocated_storage
  storage_type           = var.storage_type
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance
  name                   = var.rds_db_name
  username               = var.rds_username
  identifier             = var.db_identifier
  password               = var.rds_password
  db_subnet_group_name   = aws_db_subnet_group.rds.id
  vpc_security_group_ids = var.security_group_ids
  skip_final_snapshot    = true

  tags = {
    Name = "${var.PlaygroundName}-rds-instance"
  }
}

resource "aws_db_subnet_group" "rds" {
  name       = "${var.PlaygroundName}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.PlaygroundName}-rds-subnet-group"
  }
}