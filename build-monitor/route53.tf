resource "aws_route53_record" "build-monitor-r53-record" {
  zone_id = data.aws_ssm_parameter.root_zone_id.value
  name    = "build-monitor"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_alb.alb.dns_name]
}