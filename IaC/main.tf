<<<<<<< HEAD
############################
# Identity for policy path
############################
data "aws_caller_identity" "me" {}
data "aws_partition" "part" {}

############################
# S3 bucket for CloudTrail logs
############################
resource "aws_s3_bucket" "log_archive" {
  bucket = "${var.project}-log-archive-${random_id.suffix.hex}"
  tags   = { Project = var.project, Environment = "sprint2" }
}

# IMPORTANT: enable ACLs for CloudTrail by setting ownership controls
resource "aws_s3_bucket_ownership_controls" "log_archive" {
  bucket = aws_s3_bucket.log_archive.id
  rule {
    # CloudTrail needs to send objects with ACL "bucket-owner-full-control"
    # This setting allows ACL usage (vs BucketOwnerEnforced which disables ACLs).
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_versioning" "log_archive" {
  bucket = aws_s3_bucket.log_archive.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  bucket = aws_s3_bucket.log_archive.id
  rule {
    apply_server_side_encryption_by_default { sse_algorithm = "AES256" }
  }
}

resource "aws_s3_bucket_public_access_block" "bpa" {
  bucket                  = aws_s3_bucket.log_archive.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

# OPTIONAL but nice: keep CloudTrail objects under a prefix
locals {
  ct_prefix = "AWSLogs/${data.aws_caller_identity.me.account_id}"
}

# Exact bucket policy CloudTrail expects
resource "aws_s3_bucket_policy" "log_archive" {
  bucket = aws_s3_bucket.log_archive.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AWSCloudTrailAclCheck",
        Effect    = "Allow",
        Principal = { Service = "cloudtrail.amazonaws.com" },
        Action    = "s3:GetBucketAcl",
        Resource  = aws_s3_bucket.log_archive.arn
      },
      {
        Sid       = "AWSCloudTrailWrite",
        Effect    = "Allow",
        Principal = { Service = "cloudtrail.amazonaws.com" },
        Action    = "s3:PutObject",
        # IMPORTANT: path must be EXACTLY AWSLogs/<account-id>/*
        Resource = "${aws_s3_bucket.log_archive.arn}/${local.ct_prefix}/*",
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
  # Ensure ownership controls exist before policy (avoids conflicts)
  depends_on = [aws_s3_bucket_ownership_controls.log_archive]
}

############################
# CloudTrail (account trail)
############################
resource "aws_cloudtrail" "account_trail" {
  name           = "${var.project}-trail"
  s3_bucket_name = aws_s3_bucket.log_archive.id
  # OPTIONAL: also include prefix to match the policy path (keeps bucket tidy)
  s3_key_prefix = local.ct_prefix

  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true

  event_selector {
    include_management_events = true
    read_write_type           = "All"
  }

  tags = { Project = var.project, Environment = "sprint2" }
}
=======
resource "random_id" "suffix" { byte_length = 3 }

# Log archive bucket (immutable + encrypted)
resource "aws_s3_bucket" "log_archive" {
  bucket              = "${var.project}-log-archive-${random_id.suffix.hex}"
  object_lock_enabled = true
  tags = { Project = var.project, Environment = "sprint2" }
}

resource "aws_s3_bucket_versioning" "log_archive" {
  bucket = aws_s3_bucket.log_archive.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  bucket = aws_s3_bucket.log_archive.id
  rule { apply_server_side_encryption_by_default { sse_algorithm = "AES256" } }
}

resource "aws_s3_bucket_public_access_block" "bpa" {
  bucket = aws_s3_bucket.log_archive.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

# Required policy so CloudTrail can write to the bucket
data "aws_caller_identity" "me" {}
data "aws_partition" "current" {}

resource "aws_s3_bucket_policy" "log_archive" {
  bucket = aws_s3_bucket.log_archive.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid      = "AWSCloudTrailAclCheck",
        Effect   = "Allow",
        Principal = { Service = "cloudtrail.amazonaws.com" },
        Action   = "s3:GetBucketAcl",
        Resource = aws_s3_bucket.log_archive.arn
      },
      {
        Sid      = "AWSCloudTrailWrite",
        Effect   = "Allow",
        Principal = { Service = "cloudtrail.amazonaws.com" },
        Action   = "s3:PutObject",
        Resource = "${aws_s3_bucket.log_archive.arn}/AWSLogs/${data.aws_caller_identity.me.account_id}/*",
        Condition = { StringEquals = { "s3:x-amz-acl" = "bucket-owner-full-control" } }
      }
    ]
  })
}

# Single-account CloudTrail (multi-region, management events)
resource "aws_cloudtrail" "trail" {
  name                          = "${var.project}-trail"
  s3_bucket_name                = aws_s3_bucket.log_archive.id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true

  event_selector {
    include_management_events = true
    read_write_type           = "All"
  }

  tags = { Project = var.project, Environment = "sprint2" }
}
>>>>>>> origin/main
