locals {
  adj = jsondecode(file("./adjectives.json"))
}
locals {
  random_password = random_password.password.result
}

module "network" {
  count          = 1 // Keep as one otherwise a new vpc will be deployed for each instance. 
  source         = "./../../modules/network"
  PlaygroundName = var.PlaygroundName
}
module "workstation_role" {
  count          = 1
  source         = "./../../modules/rolePolicy"
  PlaygroundName = var.PlaygroundName
  role_policy    = file("${var.policyLocation}/assume_role.json")
  aws_iam_policy = { database = file("${var.policyLocation}/dynamo_db.json") }
}

module "workstation" {
  count              = var.deploy_count
  source             = "./../../modules/instance"
  PlaygroundName     = "${element(local.adj, count.index)}-panda-${var.PlaygroundName}-Workstation"
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
module "dns_workstation" {
  count        = var.deploy_count
  source       = "./../../modules/dns"
  instances    = var.instances
  instance_ips = element(module.workstation.*.public_ips, count.index)
  domain_name  = var.domain_name
  record_name  = "${var.PlaygroundName}-workstation-${element(local.adj, count.index)}-panda"
}
module "flights_table" {
  count          = var.deploy_count
  source         = "./../../modules/dynamodb"
  PlaygroundName = var.PlaygroundName
  name           = "playground-${element(local.adj, count.index)}-panda-flights"
  hashKey        = "number"
}
module "Passengers_table" {
  count          = var.deploy_count
  source         = "./../../modules/dynamodb"
  PlaygroundName = var.PlaygroundName
  name           = "playground-${element(local.adj, count.index)}-panda-passengers"
  hashKey        = "id"
}
