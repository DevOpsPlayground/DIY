locals {
  adj               = jsondecode(file("./adjectives.json"))
  random_password   = random_password.password.result
  database_password = random_password.db_password.result
}
module "network" {
  source           = "../../modules/network"
  required_subnets = 2
  PlaygroundName   = var.PlaygroundName
}
module "workstation_role" {
  count          = 1
  source         = "../../modules/iam"
  PlaygroundName = var.PlaygroundName
  role_policy    = file("${var.policyLocation}/assume_role.json")
  aws_iam_policy = { database = file("${var.policyLocation}/rds.json"), ssm = file("${var.policyLocation}/managed_instance.json") }
}
module "workstation" {
  count              = var.deploy_count
  source             = "../../modules/instance"
  PlaygroundName     = "${element(local.adj, count.index)}-panda-${var.PlaygroundName}-workstation"
  security_group_ids = [aws_security_group.ec2_sg.id]
  profile            = aws_iam_instance_profile.workstation_profile.name
  subnet_id          = module.network.public_subnets.0
  instance_type      = var.instance_type
  user_data = templatefile(
    "${var.scriptLocation}/may-2020.sh",
    {
      hostname     = "playground"
      username     = "playground"
      rds_username = "playground"
      rds_password = local.database_password
      rds_db_name  = var.rds_db_name
      rds_host     = module.rds[count.index].hostname
      ssh_pass     = local.random_password
      region       = var.region
      gitrepo      = "https://github.com/DevOpsPlayground/Hands-On-Ready-To-Deploy-Golang-CRUD-API.git"
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
  subnet_ids         = module.network.public_subnets
  rds_username       = var.username
  rds_password       = local.database_password
  rds_db_name        = var.rds_db_name
  security_group_ids = [aws_security_group.rds_sg.id]
}
# module "dns_workstation" {
#   count        = var.deploy_count
#   source       = "./../../modules/dns"
#   instances    = var.instances
#   instance_ips = element(module.workstation.*.public_ips, count.index)
#   domain_name  = var.domain_name
#   record_name  = "${var.PlaygroundName}-workstation-${element(local.adj, count.index)}-panda"
# }
