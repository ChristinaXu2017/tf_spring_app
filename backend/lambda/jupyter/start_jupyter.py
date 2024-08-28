import boto3
import os
import json
import time
from mRNAid_vaxpress import launch_jupyter

ec2 = boto3.client('ec2')

# store EC2 status to existing table
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(DBTABLE)  

def lambda_handler(event, context):
  print('Event Received: {}'.format(json.dumps(event)))

  # Scan the table to find an item with both 'jupyter_url' and 'instance_id'
  response = table.scan(
        FilterExpression='jupyter_url = :url AND instance_id = :instance_id',
    )

  if response['Items']:
        item = response['Items'][0]
        jupyter_url = item['jupyter_url']
        instance_id = item['instance_id']

        # Check the status of the instance
        status = ec2.describe_instances(InstanceIds=[instance_id])['Reservations'][0]['Instances'][0]['State']['Name']
        if status == "running":
            return {
                'statusCode': 400,
                'body': json.dumps({
                    'instance_id': instance_id,
                    'jupyter_url': jupyter_url,
                    'status': 'running',
                    'message': 'An instance with the Jupyter URL and instance ID already exists.'
                })
            }
        else:
            # Delete the item from DynamoDB if the instance is not running
            table.delete_item(
                Key={
                    'id': item['id']
                }
            )

  # otherwise start a new instance
  print("launching jupyter notebook to access mRNAid and vaxpress!")
  response = launch_jupyter()

  table.put_item(
      Item={
	    'id': instance_id,
            'instance_id': instance_id,
            'jupyter_url': jupyter_url,
            'status': 'running'
        }
  )
    
  return {
        'statusCode': 200,
        'body': response
  }

