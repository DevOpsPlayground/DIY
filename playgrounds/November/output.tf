output "jenkins_ips" {
  value       = module.jenkins.*.public_ips
  description = "The ip of the jenkins instances"
}
output "unique_identifier" {
  value       = module.jenkins.*.unique_identifiers
}
output "workstation_ips" {
  value       = module.workstation.*.public_ips
  description = "The ip of the workstation instances"
}
output "WorkstationPassword" {
  value       = "playground"
  description = "The password for the workstation"
}
# output "dns_workstation" {
#   value = module.dns_workstation.*.name
# }
# output "dns_jenkins" {
#   value = module.dns_jenkins.*.name
# }
