resource "aws_cloudtrail" "org_trail" {
  name                          = "${var.project}-trail"
  s3_bucket_name                = aws_s3_bucket.log_archive.id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  event_selector {
    read_write_type           = "All"
    include_management_events = true
  }
  advanced_event_selector {
    name = "S3DataEvents"
    field_selector { field = "eventCategory" equals = ["Data"] }
    field_selector { field = "resources.type" equals = ["AWS::S3::Object"] }
  }
}
