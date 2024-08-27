variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "us-east-1"
}

variable "sns_input_topic_name" {
  description = "The name of the SNS topic to which Kion posts findings to."
  type        = string
  default     = "kion-encoded-sns-topic"
}

variable "sns_output_topic_name" {
  description = "The name of the SNS topic to which the Lambda publishes decoded messages."
  type        = string
  default     = "decoded-sns-topic"
}

variable "email_subscriptions" {
  description = "A list of email addresses to subscribe to the SNS topic."
  type        = list(string)
  default     = [""]
}

variable "lambda_function_name" {
  description = "The name of the Lambda function"
  type        = string
  default     = "sns-decoder"
}

variable "sqs_input_queue_name" {
  description = "The name of the SQS queue to receive input messages."
  type        = string
  default     = "kion-input-sqs-queue"
}

variable "kion_url" {
  description = "The base URL for the Kion portal."
  type        = string
  default     = ""
}
