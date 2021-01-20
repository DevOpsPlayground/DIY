output "ips" {
  value = module.jenkins.*.public_ips
}