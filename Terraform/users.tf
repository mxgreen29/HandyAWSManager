resource "aws_iam_user" "users" {
  for_each             = var.users
  name                 = each.value
  path                 = "/"
  force_destroy        = var.force_destroy
  tags = {
    description = "User managed by terraform"
  }
}

resource "aws_iam_user_login_profile" "users" {
  for_each                = aws_iam_user.users
  user                    = each.value.name
  password_length         = var.password_length
  password_reset_required = var.password_reset_required
  lifecycle {
    ignore_changes = [password_reset_required]
  }
}

resource "aws_iam_access_key" "users_no_pgp" {
  for_each                = aws_iam_user.users
  user                    = each.value.name
}
