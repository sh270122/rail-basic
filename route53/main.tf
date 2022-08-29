resource "aws_route53_record" "record" {
  name    = "rails"
  #records = [var.alb_name]
  zone_id = var.zone-id
  type    = "A"
  #ttl     = "120"
  alias {
    name                   = var.alb_name
    zone_id                = var.zone_id
    evaluate_target_health = true
  }
}