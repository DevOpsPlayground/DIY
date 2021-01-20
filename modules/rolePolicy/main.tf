resource "aws_iam_role" "role" {
  name               = var.PlaygroundName
  assume_role_policy = var.role_policy //file("policies/assume_role.json")
  tags = {
    Purpose = "Playground"
  }
}

resource "aws_iam_policy" "policy" {
  for_each = toset(var.aws_iam_policy)
  name        = var.PlaygroundName
  description = "Permissions for Jenkins to deploy application"
  policy      = each.key //file("policies/jenkins_permissions.json")
}

resource "aws_iam_role_policy_attachment" "deploy_attachment" {
  for_each = aws_iam_policy.policy
  role       = aws_iam_role.role.name
  policy_arn = each.value.arn
}