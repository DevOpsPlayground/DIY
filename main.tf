module "network" {
  count          = 1 // Keep as one otherwise a new vpc will be deployed for each instance. 
  source         = "./modules/network"
  PlaygroundName = var.PlaygroundName
}
module "Jenkins_role" {
  count          = 1
  source         = "./modules/rolePolicy"
  PlaygroundName = var.PlaygroundName
  role_policy    = file("policies/assume_role.json")
  aws_iam_policy = { autoscale = file("policies/jenkins_autoscale.json"), ec2 = file("policies/jenkins_ec2.json"), elb = file("policies/jenkins_elb.json"), iam = file("policies/jenkins_iam.json"), s3 = file("policies/jenkins_s3.json") }
}
module "jenkins" {
  count              = var.deploy_count
  source             = "./modules/instance"
  depends_on         = [module.network]
  profile            = aws_iam_instance_profile.main_profile.name
  PlaygroundName     = "${var.PlaygroundName}Jenkins"
  instance_type      = var.instance_type
  security_group_ids = [module.network.0.allow_all_security_group_id]
  subnet_id          = module.network.0.public_subnets.0
  user_data          = file("scripts/install-jenkins.sh")
  InstanceRole       = module.Jenkins_role.0.role
}
module "workstation" {
  count              = var.enabled == true ? var.deploy_count : 0
  source             = "./modules/instance"
  profile            = aws_iam_instance_profile.main_profile.name
  PlaygroundName     = "${var.PlaygroundName}workstation"
  security_group_ids = [module.network.0.allow_all_security_group_id]
  subnet_id          = module.network.0.public_subnets.0
  instance_type      = var.instance_type
  user_data = templatefile(
    "scripts/workstation.sh",
    {
      hostname = "playground"
      username = "playground"
      ssh_pass = var.WorkstationPassword
      gitrepo  = "https://github.com/DevOpsPlayground/Hands-on-with-Jenkins-Terraform-and-AWS.git"
    }
  )
  amiName  = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"
  amiOwner = "099720109477"
}

module "dns_jenkins" {
  count        = var.deploy_count
  depends_on   = [module.workstation]
  source       = "./modules/dns"
  instances    = var.instances
  instance_ips = element(module.jenkins.*.public_ips, count.index)
  record_name  = "${var.PlaygroundName}-${element(var.adjectives, count.index)}-panda"
}

module "dns_workstation" {
  count        = var.enabled == true ? var.deploy_count : 0
  depends_on   = [module.jenkins]
  source       = "./modules/dns"
  instances    = var.instances
  instance_ips = element(module.workstation.*.public_ips, count.index)
  record_name  = "${var.PlaygroundName}-${element(var.adjectives, count.index)}-panda"
}
module "tfStateBucket" {
  count          = 1
  source         = "./modules/s3"
  PlaygroundName = var.PlaygroundName
  reason         = "tfstate"
}
module "artifactBucket" {
  count          = 1
  source         = "./modules/s3"
  PlaygroundName = var.PlaygroundName
  reason         = "artifact"
}
