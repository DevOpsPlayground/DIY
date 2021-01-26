resource "aws_iam_role" "role" {
  name               = var.PlaygroundName
  assume_role_policy = var.role_policy
  tags = {
    Purpose = var.purpose
  }
}

resource "aws_iam_policy" "policy" {
  for_each    = var.aws_iam_policy
  name        = "${var.PlaygroundName}-${each.key}"
  description = "Permissions for the resource for ${each.key}"
  policy      = each.value
}

resource "aws_iam_role_policy_attachment" "deploy_attachment" {
  for_each   = aws_iam_policy.policy
  role       = aws_iam_role.role.name
  policy_arn = each.value.arn
}