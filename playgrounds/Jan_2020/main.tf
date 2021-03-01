locals {
  adj                = jsondecode(file("./adjectives.json"))
  random_password    = random_password.password.result
}

module "network" {
  source           = "../../modules/network"
  required_subnets = 2
  PlaygroundName   = var.PlaygroundName
}

module "workstation" {
  count              = var.deploy_count
  source             = "../../modules/instance"
  PlaygroundName     = "${element(local.adj, count.index)}-panda-${var.PlaygroundName}-master-node"
  security_group_ids = [module.network.allow_all_security_group_id]
  subnet_id          = module.network.public_subnets.0
  instance_type      = var.instance_type
  user_data = templatefile(
    "${var.scriptLocation}/april-2020.sh",
    {
      hostname = "playground"
      username = "${element(local.adj, count.index)}"
      ssh_pass = local.random_password
      region   = var.region
      gitrepo  = ""
    }
  )
  amiName  = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"
  amiOwner = "099720109477"
}

# module "dns_workstation" {
#   count        = var.deploy_count
#   source       = "./../../modules/dns"
#   instances    = var.instances
#   instance_ips = element(module.workstation.*.public_ips, count.index)
#   domain_name  = var.domain_name
#   record_name  = "${var.PlaygroundName}-workstation-${element(local.adj, count.index)}-panda"
# }

