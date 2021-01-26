output "jenkins_ips" {
  value       = module.jenkins.*.public_ips
  description = "The ip of the jenkins instances"
}
output "workstation_ips" {
  value       = module.workstation.*.public_ips
  description = "The ip of the workstation instances"
}
output "WorkstationPassword" {
  value       = var.WorkstationPassword
  description = "The password of the workstation"
  sensitive   = true
}
output "TFstateBucket" {
  value       = module.tfStateBucket.*.name
  description = "The TF state bucket name"
}
output "artifactBucket" {
  value       = module.artifactBucket.*.name
  description = "The artifact bucket name"
}
output "dns_workstation" {
  value = module.dns_workstation.*.name
}

output "dns_jenkins" {
  value = module.dns_jenkins.*.name
}


