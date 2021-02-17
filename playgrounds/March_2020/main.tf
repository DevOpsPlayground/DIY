locals {
  adj             = jsondecode(file("./adjectives.json"))
  random_password = random_password.password.result
}
module "network" {
  source           = "../../modules/network"
  required_subnets = 2
  PlaygroundName   = var.PlaygroundName
}
module "workstation" {
  count              = var.deploy_count
  source             = "../../modules/instance"
  PlaygroundName     = "${element(local.adj, count.index)}-panda-${var.PlaygroundName}-workstation"
  security_group_ids = [module.network.allow_all_security_group_id]
  subnet_id          = module.network.public_subnets.0
  instance_type      = var.instance_type
  user_data = templatefile(
    "${var.scriptLocation}/march-2020.sh",
    {
      hostname = "playground"
      username = "playground"
      ssh_pass = local.random_password
      region   = var.region
      gitrepo  = "https://github.com/DevOpsPlayground/Hands-on-with-Terraform-and-Ansible.git"
    }
  )
  amiName  = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"
  amiOwner = "099720109477"
}




### IF YOU'RE USING DNS PLEASE UNCOMMENT THIS AND ADD YOU HOSTED ZONE DOMAIN NAME IN VARS.TF

# module "dns_workstation" {
#   count        = var.deploy_count
#   source       = "./../../modules/dns"
#   instances    = var.instances
#   instance_ips = element(module.workstation.*.public_ips, count.index)
#   domain_name  = var.domain_name
#   record_name  = "${var.PlaygroundName}-workstation-${element(local.adj, count.index)}-panda"
# }
