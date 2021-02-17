
output "workstation_ips" {
  value       = module.workstation.*.public_ips
  description = "The ip of the workstation instances"
}
output "remotehost_ips" {
  value       = module.remote_host.*.public_ips
  description = "The ip of the remote host instance"
}
output "WorkstationPassword" {
  value       = local.random_password
  description = "The password Used to SSH into the instance"
}

output "RemoteHostPassword" {
  value = local.RemoteHostPassword
}
output "unique_identifier" {
  value       = module.workstation.*.unique_identifiers
  description = "Unique identifiers for Workstation instances"
}
output "unique_identifier_remote_host" {
  value       = module.remote_host.*.unique_identifiers
  description = "Unique identifiers for remote_hosts instances"
}

# output "dns_workstation" {
#   value = module.dns_workstation.*.name
# }

# output "dns_remote_host" {
#   value = module.dns_remote_host.*.name
# }
