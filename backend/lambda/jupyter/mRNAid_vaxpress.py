import boto3
import os
import json
import time


ECRIMAGE = os.environ['ECR_REPO']
KEYNAME = os.environ['KEY_NAME']
SGID = os.environ['SECURITY_GROUP']
INBUCKET = os.environ['BUCKET']
EC2IAM = os.environ['EC2IAM']
AWSREGION = os.environ['REGION']
HASHPW = os.environ['HASH_JUPYTER_PW']

def launch_jupyter():
    # Parameters for launching EC2 instance
    init_script = """#!/bin/bash
   exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

    echo "Updating packages and installing Docker"
    yum update -y
    yum install -y docker

    echo "Starting Docker service"
    systemctl start docker
    systemctl enable docker

    echo "Running Docker container"
    aws ecr get-login-password --region {AWSREGION} | docker login --username AWS --password-stdin {ECRIMAGE_REGISTRY}
    docker run --rm -p 8888:8888 -e BUCKET_NAME="{INBUCKET}" -e HASHED_PW="{HASHPW}" {ECRIMAGE}

    """.format( AWSREGION=AWSREGION,INBUCKET=INBUCKET, HASHPW=HASHPW, ECRIMAGE=ECRIMAGE, ECRIMAGE_REGISTRY=ECRIMAGE.split('/')[0])
    
        # Linux arm64 2cpu 0.5GRAM 0.0053ph
        #ImageId='ami-0890e237fba7197d8',
        #InstanceType="t4g.nano",
    # Launch EC2 instance, here IAM role already attached by TF
    ec2_client = boto3.client('ec2', region_name=AWSREGION)
    response = ec2_client.run_instances(
        # try Amazon Linux 2 IAM where ssm installed
        ImageId='ami-030a5acd7c996ef60',
        InstanceType="t2.micro",
        KeyName=KEYNAME,
        SecurityGroupIds=[SGID],
        IamInstanceProfile={'Arn': EC2IAM},
        MinCount=1,
        MaxCount=1,
        UserData=init_script
    )
    
    instance_id = response['Instances'][0]['InstanceId']
    # Add name for debug in AWS console
    ec2_client.create_tags(
        Resources=[instance_id],
        Tags=[{'Key': 'Name', 'Value': "mRNA_vax_notebook"}]
    )
    
    # Wait for the instance to be running
    waiter = ec2_client.get_waiter('instance_running')
    waiter.wait(InstanceIds=[instance_id])

    # Wait for the instance status to be OK
    instance_status_waiter = ec2_client.get_waiter('instance_status_ok')
    instance_status_waiter.wait(InstanceIds=[instance_id])
    
    # Give some time for the user data script to complete
    time.sleep(60)
    
    # Describe the instance to get the public DNS
    instance_description = ec2_client.describe_instances(InstanceIds=[instance_id])
    public_dns = instance_description['Reservations'][0]['Instances'][0]['PublicDnsName']

    jupyter_url = "http://{public_dns}:8888".format(public_dns=public_dns)

    return json.dumps({
		'url': jupyter_url, 
		'instance_id': instance_id, 
		'message': 'Jupyter notebook is launched within EC2 instance successfully'
	})
