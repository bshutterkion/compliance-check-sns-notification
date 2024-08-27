# SNS Decoding and Compliance Notification Infrastructure

This repository contains Terraform configurations and related code to set up an AWS Lambda function that decodes SQS messages, processes compliance notifications, and sends email alerts using SNS. The infrastructure includes IAM roles and policies, SNS topics, SQS queues, and a Lambda function.

## Project Structure

```plaintext
.
├── sns.tf                # Defines SNS topics and subscriptions
├── data.tf               # Fetches the AWS account identity
├── cloudwatch.tf         # Configures CloudWatch log groups
├── lambdaScripts/        # Contains the Lambda function script
│   └── handler.py
├── providers.tf          # AWS provider configuration
├── variables.tf          # Variables used throughout the Terraform configuration
├── lambda.tf             # Configures the Lambda function and event sources
├── iam.tf                # IAM roles and policies for Lambda and SNS
├── sqs.tf                # Configures the SQS queue
├── sample-check.yml      # Example policy file for compliance checks
└── README.md             # Project documentation
```

### Prerequisites

- AWS CLI configured with sufficient permissions.
- Terraform installed and configured.
- Kion installed and configured.

### Setup Instructions

#### 1. Clone the Repository

```bash
git clone https://github.com/bshutterkion/compliance-check-sns-notification.git
cd compliance-check-sns-notification
```

#### 2. Modify Variables

Update the variables.tf file with your specific values:

- aws_region: Set the AWS region where you want to deploy the resources.
- sns_input_topic_name: The name of the SNS topic that receives encoded messages.
- sns_output_topic_name: The name of the SNS topic where decoded messages will be sent.
- email_subscriptions: A list of email addresses to receive notifications.
- lambda_function_name: The name of the Lambda function.
- sqs_input_queue_name: The name of the SQS queue that receives input messages.
- kion_url: The base URL for the Kion portal.

#### 3. Deploy the Infrastructure

Run the following commands to deploy the resources:

```bash
terraform init
terraform apply
```

#### 4. Lambda Function Overview

The Lambda function located in `./lambdaScripts/handler.py`:

- Decodes and decompresses SNS messages.
- Extracts compliance check information.
- Sends an email notification with a link to the compliance check details.

#### 5. Sample Policy File

A sample policy file (`sample-check.yml`) is included, demonstrating how to configure compliance checks that send notifications to the configured SQS queue.

#### 6. Outputs

After applying the Terraform configuration, you will get the following outputs:

- SNS Topic ARN: The ARN of the SNS topic where decoded messages are sent.
- SNS Topic URL: The URL for accessing the SNS topic.
- SQS Queue URL: The URL of the SQS queue receiving input messages.
- SQS Queue ARN: The ARN of the SQS queue.

#### 7. Cleaning Up

To destroy the resources created by this configuration, run:

```bash
terraform destroy
```
