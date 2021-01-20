resource "aws_instance" "jenkins" {
  count                       = var.instance_count
  ami                         = data.aws_ami.amazon-linux-2.id
  associate_public_ip_address = true
  # Does it also works for instance without the profile??? - Yes - the module you are creating!
  #iam_instance_profile   = aws_iam_instance_profile.jenkins_profile.name
  instance_type = var.instance_type
  #key_name               = var.key_name
  vpc_security_group_ids = var.security_group_ids
  subnet_id              = var.subnet_id
  user_data              = var.user_data #file("scripts/install-jenkins.sh")

  tags = {
    Name  = "dpg-jenkins-${count.index + 1}"
    Owner = "Playground"
  }
}