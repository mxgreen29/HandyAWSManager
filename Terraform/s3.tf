#=== We use Terraform module from open source for facilitate code ===#
/*
About Terraform modules:
https://learn.hashicorp.com/tutorials/terraform/module?in=terraform/modules
S3 module:
https://registry.terraform.io/modules/terraform-aws-modules/s3-bucket/aws/latest
*/

module "s3_bucket" {
  source   = "git::https://github.com/terraform-aws-modules/terraform-aws-s3-bucket.git?ref=v3.0.1"
  for_each = var.s3_bucket
  bucket   = each.value.name
  versioning = {
    enabled  = false
  }
  block_public_acls       = each.value.public ? true : false
  block_public_policy     = each.value.public ? true : false
  ignore_public_acls      = each.value.public ? true : false
  restrict_public_buckets = each.value.public ? true : false
  lifecycle_rule          = try(each.value.acl, "")

}