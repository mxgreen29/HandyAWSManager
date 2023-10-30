output "iam_user_name" {
  value = [
  for user in aws_iam_user.users : user.name
  ]
}
output "iam_user_access_key" {
  value = [
  for user in aws_iam_access_key.users_no_pgp : user.id
  ]
}
output "Public_IPs" {
  value = local.ips
}
output "Instances_id" {
  value = [for k in aws_instance.main : "${k.id} - ${k.tags.Name}.${var.public_domain}" ]
}
output "DNS_records" {
  value = [for n in aws_route53_record.route53_create_records_ec2 : n.name ]
}