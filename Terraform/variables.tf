variable "public_domain" {}
variable "iam_group" {
  type        = map(any)
  default     = {}
}
variable "users" {
  type    = map(any)
}
variable "force_destroy" {
  description = "When destroying this user, destroy even if it has non-Terraform-managed IAM access keys, login profile or MFA devices. Without force_destroy a user with non-Terraform-managed access keys and login profile will fail to be destroyed."
  type        = bool
  default     = false
}
variable "password_length" {
  description = "The length of the generated password"
  type        = number
  default     = 12
}
variable "password_reset_required" {
  description = "Whether the user should be forced to reset the generated password on first login."
  type        = bool
  default     = true
}
variable "s3_bucket" {
  type        = map(any)
  default     = {}
}
variable "region" {}
variable "short_region" {}
variable "instance" {
  description = "Map of instances names to configuration"
  type        = map(any)
  default = {}
}
variable "mysql" {
  description = "Map of instances names to configuration"
  type        = map(any)
  default = {}
}
variable "mysql_pass" {}
variable "private_subnets" {
  default = ["10.100.160.0/19", "10.100.128.0/19", "10.100.96.0/19"]
}

variable "public_subnets" {
  default = ["10.100.64.0/19", "10.100.32.0/19", "10.100.0.0/19"]
}