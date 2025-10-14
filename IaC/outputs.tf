output "log_archive_bucket" { value = aws_s3_bucket.log_archive.bucket }
output "cloudtrail_name"    { value = aws_cloudtrail.trail.name }
