data "template_file" "iam_policy" {
  template = file("${path.module}/iam_policy.json")
  vars = {
    bucket_arn = aws_s3_bucket.sync.arn
  }
}

resource "aws_iam_policy" "asustor" {
  name_prefix = "asustor-"
  description = "Asustor policy for bucket ${aws_s3_bucket.sync.id}"
  policy      = data.template_file.iam_policy.rendered
}

resource "random_string" "group_suffix" {
  length  = 16
  lower   = true
  upper   = false
  number  = true
  special = false
}

resource "aws_iam_group" "asustor" {
  name = "asustor-${random_string.group_suffix.result}"
}

resource "aws_iam_group_policy_attachment" "asustor" {
  group      = aws_iam_group.asustor.name
  policy_arn = aws_iam_policy.asustor.arn
}

resource "random_string" "user_suffix" {
  length  = 16
  lower   = true
  upper   = false
  number  = true
  special = false
}

resource "aws_iam_user" "asustor" {
  name = "asustor-${random_string.user_suffix.result}"
}

resource "aws_iam_user_group_membership" "asustor" {
  user = aws_iam_user.asustor.name

  groups = [
    aws_iam_group.asustor.name
  ]
}

resource "aws_iam_access_key" "asustor" {
  user    = aws_iam_user.asustor.name
  pgp_key = var.iam_pgp_key
}

output "access_key" {
  value       = aws_iam_access_key.asustor.id
  description = "IAM User Access Key"
}

output "access_key_secret" {
  sensitive   = true
  value       = var.iam_pgp_key == null ? aws_iam_access_key.asustor.secret : aws_iam_access_key.asustor.encrypted_secret
  description = "IAM User Access Key Secret (encrypted if iam_pgp_key was set)"
}
