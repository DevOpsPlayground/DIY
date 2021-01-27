output "public_ips" {
  value       = aws_instance.main.*.public_ip
  description = "The public ips of the workstation"
}