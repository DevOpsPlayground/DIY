output "jenkins_ips" {
  value = module.jenkins.*.public_ips
}
output "workstation_ips" {
  value = module.workstation.*.public_ips
}
output "WorkstationPassword" {
  value     = var.WorkstationPassword
  sensitive = true
}
output "TFstateBucket" {
  value = module.tfStateBucket.*.name
}
output "artifactBucket" {
  value = module.artifactBucket.*.name
}
