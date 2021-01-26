resource "aws_iam_instance_profile" "main_profile" {
  name = "${var.PlaygroundName}-instance-profile"
  role = var.InstanceRole
}

