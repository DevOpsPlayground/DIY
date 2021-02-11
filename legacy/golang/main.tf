# # # Zone ID for domains to associate with the IPs. Domain should be setup on the Training AWS account
# # # r53_zone_id = "ZHQ86ZHWMXO1D"  # *.devopsplayground.com
# # # r53_zone_id = "ZKL6DCZ2ESZ63"  # *.ldn.devopsplayground.com
# # # r53_zone_id = "Z32QV07KBPOOPC" # *.edi.devopsplayground.com

locals {
  module_source_base = "git@github.ecs-digital.co.uk/ECSD/playground-frame.git?ref=master/"
  stack_name         = "dpg-golang"
  count              = "35"
  ssh_key_name       = "DPG-digi-golang"
  ssh_user           = "playground"
  ssh_password       = "DigitalMayGolang"
  r53_zone_id        = "Z033632739IGU7AFZSR52"
  instance_type      = "t2.medium"
  rds_username       = "playground"
  rds_password       = "eak2ZcRNE8hU3V7EaxyPt7W43"
  rds_db_name        = "golangrocks"
}

module "vpc" {
  source = "./modules/vpc"
  name   = "${local.stack_name}-vpc"
}

module "animal" {
  source = "./modules/custom_animal_names"
  count  = "${local.count}"
}

#### - This is to create a ${local.count} number of userdata templates that will be passed onto the linux_instances module
#### - Put the custom install bits into that file
data "template_file" "custom_install_script_linux" {
  count    = "${local.count}"
  template = "${file("scripts/userdata.sh.tpl")}"

  vars {
    username     = "${local.ssh_user}"
    ssh_key_name = "${local.ssh_key_name}"
    rds_host     = "${module.rds.hostnames[count.index]}"
    rds_username = "${local.rds_username}"
    rds_password = "${local.rds_password}"
    rds_db_name  = "${local.rds_db_name}"
  }
}

####

module "linux_instances" {
  source                    = "./modules/custom_instance"
  count                     = "${local.count}"
  stack_name                = "${local.stack_name}"
  vpc_id                    = "${module.vpc.vpc_id}"
  subnet_ids                = "${module.vpc.public_subnets}"
  default_security_group_id = "${module.vpc.default_security_group_id}"
  animal_names              = "${module.animal.names}"

  # Can't use depends_on in module so using output of aws_key_pair is just a way to make sure that we will not get an error that the key does not exist yet.
  # That was found with ansible playground where key had to be copied to the instance

  ssh_key_name  = "${aws_key_pair.ssh_key.key_name}"
  ssh_user      = "${local.ssh_user}"
  ssh_password  = "${local.ssh_password}"
  instance_type = "${local.instance_type}"
  custom_install_scripts = "${data.template_file.custom_install_script_linux.*.rendered}"
}

# Comment out module below if you are using the module on different account than ECSD training
module "dns" {
  source       = "./modules/dns"
  count        = "${local.count}"
  r53_zone_id  = "${local.r53_zone_id}"
  animal_names = "${module.animal.names}"
  ip_addresses = "${module.linux_instances.ip_addresses}"
}

module "rds" {
  source       = "./modules/rds"
  count        = "${local.count}"
  name         = "${local.stack_name}"
  subnet_ids   = ["subnet-04548f538678257f0", "subnet-0a3bba9e985c754ba"]
  rds_username = "${local.rds_username}"
  rds_password = "${local.rds_password}"
  rds_db_name  = "${local.rds_db_name}"
  security_group_ids = ["sg-07325a6b401190f15"]
}

output "ips" {
  value = "${module.dns.fqdns}"
}

output "ssh_user" {
  value = "${local.ssh_user}"
}

output "ssh_pw" {
  value = "${local.ssh_password}"
}
output "subnets" {
    value = "${module.vpc.public_subnets}"
}
output "sgs" {
    value = "${module.vpc.default_security_group_id}"
}

# # uncomment if you are using module on different account than ECSD training and comment out "ips" output
# # output "ip_adresses" {
# #   value = "${module.linux_instances.ip_addresses}"
# # }

