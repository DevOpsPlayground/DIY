resource "aws_instance" "main" {
  count                       = var.instance_count
  ami                         = data.aws_ami.amazon-linux-2.id
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.main_profile.0.name
  instance_type               = var.instance_type
  vpc_security_group_ids      = var.security_group_ids
  subnet_id                   = var.subnet_id
  user_data                   = var.user_data

  tags = {
    Name = "${var.PlaygroundName}-${count.index + 1}"

    Purpose = "Playground"
  }
}
resource "aws_iam_instance_profile" "main_profile" {
  count = var.instance_count
  name  = "${var.PlaygroundName}-instance-profile-${count.index + 1}"
  role  = var.InstanceRole
}