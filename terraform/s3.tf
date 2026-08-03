data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "racf_state" {
  bucket = "${var.project_tag}-racf-state-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name    = "${var.project_tag}-racf-state"
    Project = var.project_tag
  }
}

resource "aws_s3_bucket_versioning" "racf_state" {
  bucket = aws_s3_bucket.racf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "racf_state" {
  bucket = aws_s3_bucket.racf_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "racf_state" {
  bucket = aws_s3_bucket.racf_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "racf_state" {
  bucket = aws_s3_bucket.racf_state.id

  rule {
    id     = "expire-noncurrent-racf-state"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }
}