#========================== DNS =====================#

data "aws_route53_zone" "selected" {
  name         = "${var.public_domain}."
}

#ec2
resource "aws_route53_record" "route53_create_records_ec2" {
  for_each = aws_instance.main
  name = "${each.value.tags.Name}.${var.public_domain}"
  records      = ["${aws_eip.main_eip[each.value.tags.Name].public_ip}"]
  zone_id  = data.aws_route53_zone.selected.zone_id
  type     = "A"
  ttl      = "60"
}
#rds record
resource "aws_route53_record" "route53_create_record_rds" {
  zone_id = data.aws_route53_zone.selected.zone_id
  for_each   = aws_db_instance.MySQL
  name    = "${each.value.tags.Name}-mysql.${var.public_domain}"
  type    = "CNAME"
  ttl     = "60"
  records = [aws_db_instance.MySQL[each.value.tags.Name].address]
}
