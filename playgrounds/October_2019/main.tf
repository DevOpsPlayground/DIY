locals {
  adj                = jsondecode(file("./adjectives.json"))
  random_password    = random_password.password.result
  RemoteHostPassword = random_password.remote_host.result
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
  security_group_ids = [aws_security_group.ec2_sg.id]
  subnet_id          = module.network.public_subnets.0
  instance_type      = var.instance_type
  user_data = templatefile(
    "${var.scriptLocation}/oct-2019.sh",
    {
      hostname = "playground"
      username = "playground"
      ssh_pass = local.random_password
      region   = var.region
      gitrepo  = "https://github.com/DevOpsPlayground/Hands-on-with-Ansible-Oct-2019.git"
    }
  )
  amiName  = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"
  amiOwner = "099720109477"
}
module "remote_host" {
  count              = var.deploy_count
  source             = "../../modules/instance"
  PlaygroundName     = "${element(local.adj, count.index)}-panda-${var.PlaygroundName}-remote-host"
  security_group_ids = [aws_security_group.ec2_sg.id]
  subnet_id          = module.network.public_subnets.0
  instance_type      = var.instance_type
  user_data = templatefile(
    "${var.scriptLocation}/oct-2019.sh",
    {
      hostname = "remote_host"
      username = "remote_host"
      ssh_pass = local.RemoteHostPassword
      region   = var.region
      gitrepo  = "https://github.com/DevOpsPlayground/Hands-on-with-Ansible-Oct-2019.git"
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

# module "dns_remote_host" {
#   count        = var.deploy_count
#   source       = "./../../modules/dns"
#   instances    = var.instances
#   instance_ips = element(module.remote_host.*.public_ips, count.index)
#   domain_name  = var.domain_name
#   record_name  = "${var.PlaygroundName}-remote_host-${element(local.adj, count.index)}-panda"
# }
