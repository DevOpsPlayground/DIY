module "network" {
  source         = "./modules/network"
  PlaygroundName = var.PlaygroundName
}
module "instance" {
  count              = 1
  depends_on         = [module.network]
  source             = "./modules/instance"
  security_group_ids = [module.network.allow_all_security_group_id]
  subnet_id          = module.network.public_subnets.1
  user_data          = file("scripts/install-jenkins.sh")
  PlaygroundName     = var.PlaygroundName
}