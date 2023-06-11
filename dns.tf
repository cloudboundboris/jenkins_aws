resource "aws_route53_record" "thecloudbrain_com" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.DOMAIN_NAME
  type    = "A"

  alias {
    name                   = module.elb.elb_dns_name
    zone_id                = module.elb.elb_zone_id
    evaluate_target_health = true
  }

}