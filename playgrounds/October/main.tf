locals {
  adj = jsondecode(file("./adjectives.json"))
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
  aws_iam_policy = { autoscale = file("${var.policyLocation}/jenkins_autoscale.json"), ec2 = file("${var.policyLocation}/jenkins_ec2.json"), elb = file("${var.policyLocation}/jenkins_elb.json"), iam = file("${var.policyLocation}/jenkins_iam.json"), s3 = file("${var.policyLocation}/jenkins_s3.json"), connect = file("${var.policyLocation}/managed_instance.json") }
}

module "workstation" {
  count              = var.deploy_count
  source             = "./../../modules/instance"
  PlaygroundName     = "${var.PlaygroundName}workstation"
  security_group_ids = [module.network.0.allow_all_security_group_id]
  subnet_id          = module.network.0.public_subnets.0
  instance_type      = var.instance_type
  key_name           = var.key_name
  user_data = templatefile(
    "${var.scriptLocation}/oct-playground.sh",
    {
      hostname = "playground"
      username = "playground"
      ssh_pass = var.WorkstationPassword
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
  record_name  = "${var.PlaygroundName}-workstation-${element(local.adj, count.index)}-panda"

}

module "flights_table" {
  source         = "./../../modules/dynamodb"
  PlaygroundName = var.PlaygroundName
  name           = "playground-${element(local.adj)}-panda-flights"
  hashKey        = "number"

}

module "Passengers_table" {
  source         = "./../../modules/dynamodb"
  PlaygroundName = var.PlaygroundName
  name           = "playground-${element(local.adj)}-panda-passengers"
  hashKey        = "id"
}