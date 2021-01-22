resource "random_pet" "instance_pet" {
}
module "network" {
  count          = 1
  source         = "./modules/network"
  PlaygroundName = var.PlaygroundName
}
module "Jenkins_role" {
  count          = 1
  source         = "./modules/rolePolicy"
  PlaygroundName = var.PlaygroundName
  role_policy    = file("policies/assume_role.json")
  aws_iam_policy = [file("policies/jenkins_permissions.json")]
}
module "jenkins" {
  count              = 1
  source             = "./modules/instance"
  depends_on         = [module.network]
  PlaygroundName     = "${var.PlaygroundName}Jenkins"
  security_group_ids = [module.network.0.allow_all_security_group_id]
  subnet_id          = module.network.0.public_subnets.0
  user_data          = file("scripts/install-jenkins.sh")
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
    "scripts/workstation.sh",
    {
      hostname = "playground"
      username = "playground"
      ssh_pass = var.WorkstationPassword
      wetty_pw = "apsiohfophfipoefhepohf"
      gitrepo  = "https://github.com/DevOpsPlayground/Hands-on-with-Jenkins-Terraform-and-AWS.git"
    }
  )
  amiName  = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"
  amiOwner = "099720109477"
}

module "dns_jenkins" {
  count          = 1
  depends_on     = [module.workstation]
  source         = "./modules/dns"
  instance_count = 1
  instance_ips   = flatten(module.jenkins.*.public_ips)
  record_name    = "${var.PlaygroundName}-workstation-${random_pet.instance_pet.id}-${count.index + 1}"
}

module "dns_workstation" {
  count          = 1
  depends_on     = [module.jenkins]
  source         = "./modules/dns"
  instance_count = 1
  instance_ips   = flatten(module.workstation.*.public_ips)
  record_name    = "${var.PlaygroundName}-jenkins-${random_pet.instance_pet.id}-${count.index + 1}"

}