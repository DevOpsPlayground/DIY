resource "aws_iam_instance_profile" "jenkins_profile" {
  name = "${var.PlaygroundName}-instance-profile"
  role = module.workstation_role.0.role
}
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}


// If more instance profiles are needed for other purposes add them below.

