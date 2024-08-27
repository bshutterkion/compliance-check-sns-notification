import json
import base64
import zlib
import boto3
import os

SNS_CLIENT = boto3.client('sns')

def send_to_sns(subject, body):
    sns_topic_arn = os.environ['SNS_OUTPUT_TOPIC_ARN']

    response = SNS_CLIENT.publish(
        TopicArn=sns_topic_arn,
        Message=body,
        Subject=subject
    )
    return response['ResponseMetadata']['HTTPStatusCode']

def handler(event, context):
    status = 500  # Default to 500 in case of an error
    kion_url = os.environ.get('KION_URL')

    for record in event['Records']:
        # Decode and decompress the message
        msg = zlib.decompress(base64.b64decode(record['body']))
        msg = json.loads(msg)

        for action in msg['policy']['actions']:
            if action['type'] == "notify":
                action_body_str = action['body']
                print("Action body before JSON parsing:", action_body_str)

                # Replace the backticks with double quotes for valid JSON
                action_body_str = action_body_str.replace('`', '"')

                try:
                    action_body = json.loads(action_body_str)
                except json.JSONDecodeError as e:
                    print("Error decoding JSON:", str(e))
                    print("Non-JSON action body after replacement:", action_body_str)
                    continue  # Skip this action if it's not a valid JSON

                # Extract the CheckId and construct the URL
                check_id = action_body.get("A Compliance Check has a finding for the check number", "unknown")
                if check_id != "unknown":
                    compliance_check_url = f"{kion_url}portal/compliance-check/{check_id}"
                    # Create a plain text message
                    body = (
                        f"A Compliance Check has a finding for the check number: {check_id}. "
                        f"The link to the finding is {compliance_check_url}"
                    )
                    subject = "Compliance Check Notification"
                    status = send_to_sns(subject, body)

    return {
        'statusCode': status,
        'body': json.dumps('Message sent to SNS')
    }
