output "jenkins_ips" {
  value = module.jenkins.*.public_ips
}
output workstation_ips{
  value = module.workstation.*.public_ips
}