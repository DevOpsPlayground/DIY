locals {
  adj               = jsondecode(file("./adjectives.json"))
  random_password   = random_password.password.result
  database_password = random_password.db_password.result
}
module "network" {
  count            = 1 // Keep as one otherwise a new vpc will be deployed for each instance. 
  source           = "../../modules/network"
  required_subnets = 2
  PlaygroundName   = var.PlaygroundName
}
module "workstation_role" {
  count          = 1
  source         = "../../modules/iam"
  PlaygroundName = var.PlaygroundName
  role_policy    = file("${var.policyLocation}/assume_role.json")
  aws_iam_policy = { database = file("${var.policyLocation}/dynamo_db.json") }
}
module "workstation" {
  count              = var.deploy_count
  source             = "../../modules/instance"
  PlaygroundName     = "${element(local.adj, count.index)}-panda-${var.PlaygroundName}-workstation"
  security_group_ids = [module.network.0.allow_all_security_group_id]
  profile            = aws_iam_instance_profile.workstation_profile.name
  subnet_id          = module.network.0.public_subnets.0
  instance_type      = var.instance_type
  user_data = templatefile(
    "${var.scriptLocation}/oct-playground.sh",
    {
      hostname = "playground"
      username = "playground"
      ssh_pass = local.random_password
      region   = var.region
      gitrepo  = "https://github.com/DevOpsPlayground/Introduction-to-GraphQL-with-GO.git"
    }
  )
  amiName  = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"
  amiOwner = "099720109477"
}
module "rds" {
  source             = "../../modules/rds"
  PlaygroundName     = "${element(local.adj, count.index)}-panda-${var.PlaygroundName}"
  db_identifier      = "${element(local.adj, count.index)}panda"
  count              = var.deploy_count
  subnet_ids         = module.network[count.index].public_subnets
  rds_username       = var.username
  rds_password       = local.database_password
  rds_db_name        = "oct"
  security_group_ids = [module.network.0.allow_all_security_group_id]
}
# module "dns_workstation" {
#   count        = var.deploy_count
#   source       = "./../../modules/dns"
#   instances    = var.instances
#   instance_ips = element(module.workstation.*.public_ips, count.index)
#   domain_name  = var.domain_name
#   record_name  = "${var.PlaygroundName}-workstation-${element(local.adj, count.index)}-panda"
# }
