import boto3
import os
import json

DYTABLE = os.environ['DYNAMO_TABLE']

ec2 = boto3.client('ec2')

# Store EC2 status to existing table
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(DYTABLE)

def lambda_handler(event, context):
    print('Event Received: {}'.format(json.dumps(event)))

    # Define jupyter_url and instance_id from event or other sources
    jupyter_url = event.get('jupyter_url')
    instance_id = event.get('instance_id')

    if not jupyter_url or not instance_id:
        return {
            'statusCode': 400,
            'body': json.dumps({
                'message': 'jupyter_url and instance_id must be provided in the event.'
            })
        }

    # Check if an instance with the Jupyter URL is already running
    response = table.scan(
        FilterExpression='jupyter_url = :url AND instance_id = :instance_id',
        ExpressionAttributeValues={
            ':url': jupyter_url,
            ':instance_id': instance_id
        }
    )

    if response['Items']:
        item = response['Items'][0]
        status = ec2.describe_instances(InstanceIds=[instance_id])['Reservations'][0]['Instances'][0]['State']['Name']
        if status == "running":
            ec2.stop_instances(InstanceIds=[instance_id])
            ec2.get_waiter('instance_stopped').wait(InstanceIds=[instance_id])

        # Delete the item from DynamoDB
        table.delete_item(
            Key={ 'id': item['id'] }
        )
        
        return {
            'statusCode': 200,
            'body': json.dumps({
                'instance_id': instance_id,
                'jupyter_url': jupyter_url,
                'status': 'stopped',
                'message': 'The instance with the Jupyter URL has been stopped and deleted from DynamoDB.'
            })
        }

    else:
        return {
            'statusCode': 400,
            'body': json.dumps({
                'instance_id': instance_id,
                'jupyter_url': jupyter_url,
                'status': 'unknown',
                'message': 'An instance with the Jupyter URL does not exist.'
            })
        }



