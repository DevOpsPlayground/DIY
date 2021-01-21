data "aws_route53_zone" "playground_hostedzone" {
  name         = "devopsplayground.org"
  private_zone = false
}