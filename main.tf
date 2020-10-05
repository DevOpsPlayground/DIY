resource "aws_iam_role" "jenkins_role" {
  name               = "jenkins_role"
  assume_role_policy = file("policies/assume_role.json")
  tags = {
    Owner   = "Richie Ganney"
    Purpose = "dpg november"
  }
}

resource "aws_iam_role_policy_attachment" "jenkins_role_policy_attach" {
  role       = aws_iam_role.jenkins_role.name
  count      = length(var.iam_policy_arns)
  policy_arn = var.iam_policy_arns[count.index]
}

resource "aws_iam_instance_profile" "jenkins_profile" {
  name = "jenkins_profile"
  role = aws_iam_role.jenkins_role.name
}

resource "aws_instance" "jenkins" {
  count                       = var.instance_count
  ami                         = data.aws_ami.amazon-linux-2.id
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.jenkins_profile.name
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [var.security_group_id]
  subnet_id                   = var.subnet_id
  user_data                   = file("scripts/install-jenkins.sh")

  tags = {
    Name  = "dpg-jenkins-${count.index + 1}"
    Owner = "Richie Ganney"
  }
}