resource "null_resource" "zip_lambda_function" {
  provisioner "local-exec" {
    command = "zip -r lambdaScripts/handler.zip lambdaScripts/handler.py"
  }

  triggers = {
    filesha = filesha256("lambdaScripts/handler.py")
  }
}

resource "aws_lambda_function" "sns_decoder" {
  filename      = "lambdaScripts/handler.zip"
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "lambdaScripts.handler.handler"
  runtime       = "python3.9"

  source_code_hash = filebase64sha256("lambdaScripts/handler.zip")

  environment {
    variables = {
      EMAIL_RECIPIENTS     = join(",", var.email_subscriptions)
      SNS_OUTPUT_TOPIC_ARN = aws_sns_topic.decoded_sns_topic.arn
      KION_URL             = var.kion_url
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_execution_policy,
    aws_iam_role_policy_attachment.lambda_cloudwatch_policy,
    aws_cloudwatch_log_group.lambda_log_group,
    null_resource.zip_lambda_function
  ]
}



resource "aws_lambda_event_source_mapping" "sqs_event_source" {
  event_source_arn = aws_sqs_queue.input_sqs_queue.arn
  function_name    = aws_lambda_function.sns_decoder.arn
}
