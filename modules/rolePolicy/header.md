# DPG - rolePolicy module

This creates the iam role.

example

``` HCL
  PlaygroundName = var.PlaygroundName
  role_policy    = assume_role.json")
  aws_iam_policy = { autoscale = file("jenkins_autoscale.json"), ec2 = file("jenkins_ec2.json")}

```

This will create a role that has the "jenkins_autoscale" and "jenkins_ec2") policys attached
