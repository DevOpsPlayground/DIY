resource "aws_iam_instance_profile" "jenkins_profile" {
  name = "${var.PlaygroundName}-instance-profile"
  role = module.workstation_role.0.role
}


// If more instance profiles are needed for other purposes add them below.

