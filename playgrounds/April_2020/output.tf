
output "MasterNodeIps" {
  value       = module.master_node.*.public_ips
  description = "IP's of the master node instances"
}
output "WorkerNodeIps" {
  value       = module.worker_node.*.public_ips
  description = "The IP's of child node instances"
}
output "MasterNodePassword" {
  value       = local.random_password
  description = "The password Used to SSH into the instance"
}

output "WorkerNodePassword" {
  value = local.WorkerNodePassword
}
output "UniqueIdentifierMasterNode" {
  value       = module.master_node.*.unique_identifiers
  description = "Unique identifiers for Workstation instances"
}
output "UniqueIdentifierChildNode" {
  value       = module.worker_node.*.unique_identifiers
  description = "Unique identifiers for remote_hosts instances"
}

# output "dns_workstation" {
#   value = module.dns_master_node.*.name
# }

# output "dns_remote_host" {
#   value = module.dns_worker_node.*.name
# }
