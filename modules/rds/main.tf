
resource "aws_db_instance" "postgres" {
  count                  = var.count
  allocated_storage      = var.allocated_storage
  storage_type           = var.storage_type
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance
  name                   = var.rds_db_name
  username               = var.rds_username
  password               = var.rds_password
  db_subnet_group_name   = aws_db_subnet_group.rds.id
  vpc_security_group_ids = var.security_group_ids
  identifier             = "${var.instance_name}-${count.index}"
  skip_final_snapshot    = true

  tags = {
    Name = "${var.name}-rds-instance"
  }
}

resource "aws_db_subnet_group" "rds" {
  name       = "rds_group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.name}-rds-subnet-group"
  }
}