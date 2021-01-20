module "network" {
  count = 1
  source         = "./modules/network"
  PlaygroundName = var.PlaygroundName
}
module "Jenkins_role" {
  count = 1
  source             = "./modules/rolePolicy"
  PlaygroundName     = var.PlaygroundName
  role_policy = file("policies/assume_role.json")
  aws_iam_policy     = [file("policies/jenkins_permissions.json")]
}
module "jenkins" {
  count              = 1
  source             = "./modules/instance"
  depends_on         = [module.network]
  PlaygroundName     = "${var.PlaygroundName}Jenkins"
  security_group_ids = [module.network.0.allow_all_security_group_id]
  subnet_id          = module.network.0.public_subnets.0
  user_data          = file("scripts/install-jenkins.sh")
  InstanceRole       = module.Jenkins_role.0.role
}
module "workstation" {
  count              = 1
  source             = "./modules/instance"
  PlaygroundName     = "${var.PlaygroundName}workstation"
  security_group_ids = [module.network.0.allow_all_security_group_id]
  subnet_id          = module.network.0.public_subnets.0
}