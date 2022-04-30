resource "aws_s3_bucket" "sync" {
  bucket_prefix = "asustor-nas-"
  acl           = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "RecycleDeletedObjects"
    enabled = true

    noncurrent_version_transition {
      days          = var.noncurrent_version_transition_days
      storage_class = var.noncurrent_version_transition_storage_class
    }

    noncurrent_version_expiration {
      days = var.noncurrent_version_expiration_days
    }
  }
}

output "bucket" {
  value       = aws_s3_bucket.sync.id
  description = "Bucket name"
}

resource "aws_s3_bucket_policy" "sync" {
  bucket = aws_s3_bucket.sync.id
  policy = templatefile("${path.module}/s3_policy.json", {
    bucket_arn = aws_s3_bucket.sync.arn
  })
}
