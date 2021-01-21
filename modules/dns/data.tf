data "aws_route53_zone" "playground_hostedzone" {
  name         = var.zone_name
  private_zone = false

}