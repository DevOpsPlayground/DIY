
resource "aws_route53_record" "instances" {
  count   = var.instance_count
  zone_id = data.aws_route53_zone.playground_hostedzone.id
  name    = var.record_name
  type    = var.record_type
  ttl     = var.record_ttl
  records = var.instance_ips
}

