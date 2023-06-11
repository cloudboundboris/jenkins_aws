resource "aws_acm_certificate" "cert1" {
  domain_name       = var.DOMAIN_NAME
  validation_method = "DNS"


  tags = {
    Name        = "${var.PROJECT_NAME}_cert1"
    Terraform   = "true"
    Environment = "dev"


  }
}

data "aws_route53_zone" "main" {
  name = var.DOMAIN_NAME
}

resource "aws_route53_record" "record1" {
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.cert1.domain_validation_options)[0].resource_record_name
  type            = tolist(aws_acm_certificate.cert1.domain_validation_options)[0].resource_record_type
  zone_id         = data.aws_route53_zone.main.zone_id
  records         = [tolist(aws_acm_certificate.cert1.domain_validation_options)[0].resource_record_value]
  ttl             = "60"

}

resource "aws_acm_certificate_validation" "cert1" {
  certificate_arn = aws_acm_certificate.cert1.arn

  validation_record_fqdns = [
    "${aws_route53_record.record1.fqdn}"
  ]

}