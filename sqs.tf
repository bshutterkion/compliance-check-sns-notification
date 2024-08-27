resource "aws_sqs_queue" "input_sqs_queue" {
  name                       = var.sqs_input_queue_name
  visibility_timeout_seconds = 30
  message_retention_seconds  = 86400
  receive_wait_time_seconds  = 0
}

output "input_sqs_queue_url" {
  value = aws_sqs_queue.input_sqs_queue.url
}

output "input_sqs_queue_arn" {
  value = aws_sqs_queue.input_sqs_queue.arn
}
