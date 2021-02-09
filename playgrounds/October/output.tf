
output "workstation_ips" {
  value       = module.workstation.*.public_ips
  description = "The ip of the workstation instances"
}
output "WorkstationPassword" {
  value       = local.random_password
  description = "The password of the workstation"

}

output "dns_workstation" {
  value = module.dns_workstation.*.name
}



