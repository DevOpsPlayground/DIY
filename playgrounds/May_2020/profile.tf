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




