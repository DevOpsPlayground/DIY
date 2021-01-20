resource "aws_iam_role" "role" {
  name               = var.PlaygroundName
  assume_role_policy = var.assume_role_policy //file("policies/assume_role.json")
  tags = {
    Purpose = "Playground"
  }
}

resource "aws_iam_policy" "policy" {
  name        = "dpg-jenkins-deploy-policy"
  description = "Permissions for Jenkins to deploy application"
  policy      = var.aws_iam_policy //file("policies/jenkins_permissions.json")
}

resource "aws_iam_role_policy_attachment" "deploy_attachment" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}