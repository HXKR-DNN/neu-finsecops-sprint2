<<<<<<< HEAD
resource "aws_opensearch_domain" "main" {
  domain_name    = "${var.project}-os"
  engine_version = "OpenSearch_2.13"

  cluster_config {
    instance_type          = "t3.small.search"
    instance_count         = 2
    zone_awareness_enabled = true
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 50
    volume_type = "gp3"
  }

  encrypt_at_rest {
    enabled = true
  }

  node_to_node_encryption {
    enabled = true
  }

  domain_endpoint_options {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }

  tags = { Project = var.project, Environment = "sprint2" }
}
=======
resource "aws_cloudwatch_log_group" "apigw" { name = "/apigw/neufinsecops/access" retention_in_days = 90 }
resource "aws_lambda_function" "apigw_to_os" {
  function_name = "${var.project}-apigw-to-os"
  role          = aws_iam_role.lambda_role.arn
  handler       = "app.lambda_handler"
  runtime       = "python3.11"
  filename      = "lambda_apigw_to_os.zip"
  environment { variables = { OPENSEARCH_ENDPOINT = aws_opensearch_domain.main.endpoint INDEX="apigw-access" } }
}
resource "aws_cloudwatch_log_subscription_filter" "apigw_stream" {
  name            = "${var.project}-apigw-sub"
  log_group_name  = aws_cloudwatch_log_group.apigw.name
  filter_pattern  = ""
  destination_arn = aws_lambda_function.apigw_to_os.arn
}
>>>>>>> origin/main
