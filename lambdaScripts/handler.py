import json
import base64
import os
import boto3

def lambda_handler(event, context):
    # Extract the SNS message
    sns_message = event['Records'][0]['Sns']['Message']
    decoded_message = base64.b64decode(sns_message).decode('utf-8')
    message_json = json.loads(decoded_message)

    # Create a generic subject and body for the notification
    subject = f"Notification: {message_json.get('subject', 'No Subject')}"
    body = f"Message Details:\n{json.dumps(message_json, indent=2)}"

    # Send the message to the SNS topic
    send_to_sns(subject, body)

def send_to_sns(subject, body):
    sns_client = boto3.client('sns')
    sns_topic_arn = os.environ['SNS_OUTPUT_TOPIC_ARN']

    response = sns_client.publish(
        TopicArn=sns_topic_arn,
        Message=body,
        Subject=subject
    )