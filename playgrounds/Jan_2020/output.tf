
output "MasterNodeIps" {
  value       = module.master_node.*.public_ips
  description = "IP's of the master node instances"
}

output "WorkstationPassword" {
  value       = local.random_password
  description = "The password Used to SSH into the instance"
}


# output "dns_workstation" {
#   value = "${module.dns_master_node.*.name}.devopsplayground.org"
# }

