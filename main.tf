module "network" {
  source         = "./modules/network"
  PlaygroundName = var.PlaygroundName
}
module "Jenkins_iam" {
  source             = "./modules/iam"
  PlaygroundName     = var.PlaygroundName
  assume_role_policy = file("policies/assume_role.json")
  aws_iam_policy     = file("policies/jenkins_permissions.json")
}
module "jenkins" {
  count              = 1
  source             = "./modules/instance"
  depends_on         = [module.network]
  PlaygroundName     = "${var.PlaygroundName}Jenkins"
  security_group_ids = [module.network.allow_all_security_group_id]
  subnet_id          = module.network.public_subnets.1
  user_data          = file("scripts/install-jenkins.sh")
  InstanceRole       = module.Jenkins_iam.role
}
module "workstation" {
  count              = 1
  source             = "./modules/instance"
  PlaygroundName     = "${var.PlaygroundName}workstation"
  security_group_ids = [module.network.allow_all_security_group_id]
  subnet_id          = module.network.public_subnets.1
}