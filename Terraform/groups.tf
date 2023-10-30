// IAM user's group with polices \\

resource "aws_iam_group" "iam_group" {
  for_each = var.iam_group
  name = each.value.name
}

resource "aws_iam_group_membership" "iam_group" {
  for_each = aws_iam_group.iam_group
  name = each.value.name
  users = concat([for u in aws_iam_user.users : u.name])
  group = each.value.name
}

resource "aws_iam_group_policy_attachment" "policy_attach" {
  for_each   = var.iam_group
  group      = aws_iam_group.iam_group[each.value.name].id
  policy_arn = each.value.policy_arn
}