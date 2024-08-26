resource "aws_sns_topic" "input_sns_topic" {
  name = var.sns_input_topic_name

  lambda_success_feedback_role_arn    = aws_iam_role.sns_success_delivery_role.arn
  lambda_success_feedback_sample_rate = 100
  lambda_failure_feedback_role_arn    = aws_iam_role.sns_failed_delivery_role.arn
}

resource "aws_sns_topic" "decoded_sns_topic" {
  name = var.sns_output_topic_name
}

resource "aws_sns_topic_subscription" "lambda_subscription" {
  topic_arn = aws_sns_topic.input_sns_topic.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.sns_decoder.arn
}

resource "aws_sns_topic_subscription" "email_subscriptions" {
  count     = length(var.email_subscriptions)
  topic_arn = aws_sns_topic.decoded_sns_topic.arn
  protocol  = "email"
  endpoint  = element(var.email_subscriptions, count.index)
}
