resource "aws_sns_topic" "decoded_sns_topic" {
  name = var.sns_output_topic_name
}

resource "aws_sns_topic_subscription" "email_subscriptions" {
  count     = length(var.email_subscriptions)
  topic_arn = aws_sns_topic.decoded_sns_topic.arn
  protocol  = "email"
  endpoint  = element(var.email_subscriptions, count.index)
}

output "decoded_sns_topic_arn" {
  value = aws_sns_topic.decoded_sns_topic.arn
}

output "decoded_sns_topic_url" {
  value = "https://sns.${var.aws_region}.amazonaws.com/${data.aws_caller_identity.current.account_id}/${aws_sns_topic.decoded_sns_topic.name}"
}
