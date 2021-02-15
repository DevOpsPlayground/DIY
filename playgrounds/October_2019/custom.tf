resource "aws_iam_instance_profile" "workstation_profile" {
  name = "${var.PlaygroundName}-instance-profile"
  role = module.workstation_role.0.role
}
resource "random_password" "password" {
  length  = 16
  special = true
}
resource "random_password" "db_password" {
  length  = 16
  special = false
}

# custom security groups
resource "aws_security_group" "rds_sg" {
  name        = "rds_security_group"
  description = "Allow all inbound traffic from workstation"
  vpc_id      = module.network.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.PlaygroundName}-rds-sg"
    Purpose = "Playground"
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2_security_group"
  description = "Allow all traffic and RDS"
  vpc_id      = module.network.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.PlaygroundName}-ec2-sg"
    Purpose = "Playground"
  }
}

resource "aws_security_group_rule" "ec2_ingress_from_rds" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  description              = "Allow incoming from RDS SG"
  source_security_group_id = aws_security_group.rds_sg.id
  security_group_id        = aws_security_group.ec2_sg.id
}

resource "aws_security_group_rule" "ec2_ingress_from_anywhere" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2_sg.id
  description       = "Allow ingress from anywhere"
}
