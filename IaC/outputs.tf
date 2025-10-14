output "log_archive_bucket" {
  value       = aws_s3_bucket.log_archive.bucket
  description = "S3 bucket receiving CloudTrail logs"
}

output "cloudtrail_name" {
  value = coalesce(
    try(aws_cloudtrail.account_trail[0].name, null),
    try(aws_cloudtrail.org_trail[0].name, null)
  )
  description = "Name of the CloudTrail created"
}
