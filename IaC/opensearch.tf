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
