
output "workstation_ips" {
  value       = module.workstation.*.public_ips
  description = "The ip of the workstation instances"
}
output "WorkstationPassword" {
  value       = local.random_password
  description = "The password Used to SSH into the instance"
}
output "dns_workstation" {
  value = module.dns_workstation.*.name
}
output "unique_identifier" {
  value       = module.workstation.*.unique_identifiers
  description = "Unique identifiers for Workstation instances"
}
