module "network" {
  count          = 1
  source         = "./modules/network"
  PlaygroundName = var.PlaygroundName
}
module "Jenkins_role" {
  count          = 1
  source         = "./modules/rolePolicy"
  PlaygroundName = var.PlaygroundName
  role_policy    = file("${var.policyLocation}/assume_role.json")
  aws_iam_policy = { autoscale = file("${var.policyLocation}/jenkins_autoscale.json"), ec2 = file("${var.policyLocation}/jenkins_ec2.json"), elb = file("${var.policyLocation}/jenkins_elb.json"), iam = file("${var.policyLocation}/jenkins_iam.json"), s3 = file("${var.policyLocation}/jenkins_s3.json") }
}
module "jenkins" {
  count              = 1
  source             = "./modules/instance"
  depends_on         = [module.network]
  PlaygroundName     = "${var.PlaygroundName}Jenkins"
  instance_type      = "t2.medium"
  security_group_ids = [module.network.0.allow_all_security_group_id]
  subnet_id          = module.network.0.public_subnets.0
  user_data          = file("${var.scriptLocation}/install-jenkins.sh")
  InstanceRole       = module.Jenkins_role.0.role
}
module "workstation" {
  count              = 1
  source             = "./modules/instance"
  PlaygroundName     = "${var.PlaygroundName}workstation"
  security_group_ids = [module.network.0.allow_all_security_group_id]
  subnet_id          = module.network.0.public_subnets.0
  instance_type      = "t2.medium"
  user_data = templatefile(
    "${var.scriptLocation}/workstation.sh",
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

#TODO an s3 module - for artifact and state saving in the nov playground

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