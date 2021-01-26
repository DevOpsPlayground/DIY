output "zone_id" {
  value = data.aws_route53_zone.playground_hostedzone.name
}

output "name" {
  description = "name of dns record created"
  value       = "aws_route53_record.instances.name"
}