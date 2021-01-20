output "ips" {
  value = module.instance.*.public_ips
}