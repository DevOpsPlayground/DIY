resource "aws_iam_role" "jenkins_role" {
  name               = "jenkins_role"
  assume_role_policy = file("policies/assume_role.json")
  tags = {
    Owner   = "Richie Ganney"
    Purpose = "dpg november"
  }
}

resource "aws_iam_policy" "jenkins_deploy_policy" {
  name        = "dpg-jenkins-deploy-policy"
  description = "Permissions for Jenkins to deploy application"
  policy      = file("policies/jenkins_permissions.json")
}

resource "aws_iam_role_policy_attachment" "deploy_attachment" {
  role       = aws_iam_role.jenkins_role.name
  policy_arn = aws_iam_policy.jenkins_deploy_policy.arn
}

resource "aws_iam_instance_profile" "jenkins_profile" {
  name = "jenkins_profile"
  role = aws_iam_role.jenkins_role.name
}