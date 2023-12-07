data "aws_route53_zone" "rootdomain" {
  name         = var.domain_name
  private_zone = false
}
