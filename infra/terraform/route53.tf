
# Route53 ゾーンの参照
data "aws_route53_zone" "main" {
  name         = var.domain_name
  private_zone = false
}

# あとで修正する
# resource "aws_route53_record" "main" {
#   zone_id = data.aws_route53_zone.main.zone_id
#   name    = "mokonyan.${data.aws_route53_zone.main.name}"
#   type    = "A"
#   ttl     = 300
#   records = [aws_lightsail_static_ip.app.ip_address]
# }
