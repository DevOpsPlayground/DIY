# DPG - Instances module

This module creates the ec2 instances used by the playgrounds

``` HCL
module "jenkins" {
  source             = "./../../modules/instance"
  depends_on         = [module.network]
  profile            = aws_iam_instance_profile.jenkins_profile.name
  PlaygroundName     = "${var.PlaygroundName}Jenkins"
  instance_type      = var.instance_type
  security_group_ids = [module.network.0.allow_all_security_group_id]
  subnet_id          = module.network.0.public_subnets.0
  user_data          = file("${var.scriptLocation}/install-jenkins.sh")
}

```
