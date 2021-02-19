locals {
  adj                = jsondecode(file("./adjectives.json"))
  random_password    = random_password.password.result
  WorkerNodePassword = random_password.remote_host.result
}
module "network" {
  source           = "../../modules/network"
  required_subnets = 2
  PlaygroundName   = var.PlaygroundName
}
module "master_node" {
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
      username = "master-node"
      ssh_pass = local.random_password
      region   = var.region
      gitrepo  = "https://github.com/DevOpsPlayground/Hands-on-with-container-orchestration-using-Docker-Swarm-and-Kubernetes.git"
    }
  )
  amiName  = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"
  amiOwner = "099720109477"
}
module "worker_node" {
  count              = var.deploy_count
  source             = "../../modules/instance"
  PlaygroundName     = "${element(local.adj, count.index)}-panda-${var.PlaygroundName}-child-node"
  security_group_ids = [module.network.allow_all_security_group_id]
  subnet_id          = module.network.public_subnets.0
  instance_type      = var.instance_type
  user_data = templatefile(
    "${var.scriptLocation}/april-2020.sh",
    {
      hostname = "playground"
      username = "worker-node"
      ssh_pass = local.WorkerNodePassword
      region   = var.region
      gitrepo  = "https://github.com/DevOpsPlayground/Hands-on-with-container-orchestration-using-Docker-Swarm-and-Kubernetes.git"
    }
  )
  amiName  = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"
  amiOwner = "099720109477"
}
# module "dns_master_node" {
#   count        = var.deploy_count
#   source       = "./../../modules/dns"
#   instances    = var.instances
#   instance_ips = element(module.master_node.*.public_ips, count.index)
#   domain_name  = var.domain_name
#   record_name  = "${var.PlaygroundName}-master_node-${element(local.adj, count.index)}-panda"
# }

# module "dns_worker_node" {
#   count        = var.deploy_count
#   source       = "./../../modules/dns"
#   instances    = var.instances
#   instance_ips = element(module.worker_node.*.public_ips, count.index)
#   domain_name  = var.domain_name
#   record_name  = "${var.PlaygroundName}-worker_node-${element(local.adj, count.index)}-panda"
# }
