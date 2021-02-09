locals {
  adj = jsondecode(file("./adjectives.json"))
}
module "network" {
  count          = 1 // Keep as one otherwise a new vpc will be deployed for each instance. 
  source         = "./../../modules/network"
  PlaygroundName = var.PlaygroundName
}
module "Jenkins_role" {
  count          = 1
  source         = "./../../modules/rolePolicy"
  PlaygroundName = var.PlaygroundName
  role_policy    = file("${var.policyLocation}/assume_role.json")
  aws_iam_policy = { autoscale = file("${var.policyLocation}/jenkins_autoscale.json"), ec2 = file("${var.policyLocation}/jenkins_ec2.json"), elb = file("${var.policyLocation}/jenkins_elb.json"), iam = file("${var.policyLocation}/jenkins_iam.json"), s3 = file("${var.policyLocation}/jenkins_s3.json") }
}
module "jenkins" {
  count              = var.deploy_count
  source             = "./../../modules/instance"
  depends_on         = [module.network]
  profile            = aws_iam_instance_profile.jenkins_profile.name
  PlaygroundName     = "${element(local.adj, count.index)}-panda-${var.PlaygroundName}Jenkins"
  instance_type      = var.instance_type
  security_group_ids = [module.network.0.allow_all_security_group_id]
  subnet_id          = module.network.0.public_subnets.0
  user_data          = file("${var.scriptLocation}/install-jenkins.sh")
}
module "workstation" {
  count              = var.deploy_count
  source             = "./../../modules/instance"
  PlaygroundName     = "${var.PlaygroundName}workstation"
  security_group_ids = [module.network.0.allow_all_security_group_id]
  subnet_id          = module.network.0.public_subnets.0
  instance_type      = var.instance_type
  user_data = templatefile(
    "${var.scriptLocation}/workstation.sh",
    {
      hostname = "playground"
      username = "playground"
      ssh_pass = "playground"
      gitrepo  = "https://github.com/DevOpsPlayground/Hands-on-with-Jenkins-Terraform-and-AWS.git"
    }
  )
  amiName  = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"
  amiOwner = "099720109477"
}
# module "dns_jenkins" {
#   count        = var.deploy_count
#   depends_on   = [module.workstation]
#   source       = "./../../modules/dns"
#   domain_name  = var.domain_name
#   instances    = var.instance_count
#   instance_ips = element(module.jenkins.*.public_ips, count.index)
#   record_name  = "${var.PlaygroundName}-jenkins-${element(local.adj, count.index)}-panda"
# }
# module "dns_workstation" {
#   count        = var.deploy_count
#   depends_on   = [module.jenkins]
#   source       = "./../../modules/dns"
#   domain_name  = var.domain_name
#   instances    = var.instance_count
#   instance_ips = element(module.workstation.*.public_ips, count.index)
#   record_name  = "${var.PlaygroundName}-workstation-${element(local.adj, count.index)}-panda"
# }
module "tfStateBucket" {
  count          = 1
  source         = "./../../modules/s3"
  PlaygroundName = var.PlaygroundName
  reason         = "tfstate"
}
module "artifactBucket" {
  count          = 1
  source         = "./../../modules/s3"
  PlaygroundName = var.PlaygroundName
  reason         = "artifact"
}
