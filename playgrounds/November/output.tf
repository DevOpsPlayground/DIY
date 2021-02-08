output "jenkins_ips" {
  value       = module.jenkins.*.public_ips
  description = "The ip of the jenkins instances"
}
