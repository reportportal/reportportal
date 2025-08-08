# S3-Based Storage Using IAM Role for EC2 Docker-based ReportPortal

This document outlines the requirements and configuration steps to enable read/write access to Amazon S3 from a Dockerized ReportPortal installation on an Amazon EC2 instance using IAM roles (Instance Profiles). This setup leverages role-based authentication provided by the EC2 Instance Metadata Service (IMDS).

## Table of Contents

- [Requirements](#requirements)
- [S3 Bucket](#1-s3-bucket)
- [AWS IAM Role](#2-aws-iam-role)
  - [Step 1: Define the Trust Policy](#step-1-define-the-trust-policy)
  - [Step 2: Create the IAM Role](#step-2-create-the-iam-role)
  - [Step 3: Define the Permissions Policy](#step-3-define-the-permissions-policy)
  - [Step 4: Attach the Permissions Policy](#step-4-attach-the-permissions-policy)
- [IAM Instance Profile](#3-iam-instance-profile)
  - [Step 1: Create an Instance Profile](#step-1-create-an-instance-profile)
  - [Step 2: Attach the Role to the Instance Profile](#step-2-attach-the-role-to-the-instance-profile)
  - [Step 3: Associate the Profile with the EC2 Instance](#step-3-associate-the-profile-with-the-ec2-instance)
  - [Step 4: Enable Instance Metadata Access](#step-4-enable-instance-metadata-access)
- [ReportPortal Configuration](#4-reportportal-configuration)
- [Docker-Based Installation](#5-docker-based-installation)

## Requirements

1. An Amazon EC2 instance with Docker and Docker Compose installed.
2. An Amazon S3 bucket.
3. AWS IAM role configured with appropriate trust and permissions policies.
4. Instance metadata service (IMDSv2) enabled on the EC2 instance.

## 1. S3 Bucket

Create an Amazon S3 bucket to store ReportPortal data:

```bash
aws s3api create-bucket --bucket my-rp-docker-bucket --region us-east-1
```

> 💡 To create a bucket outside `us-east-1`, add the following option:
>
> ```bash
> --create-bucket-configuration LocationConstraint=<region>
> ```

Ensure your bucket name complies with [S3 bucket naming rules](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html).

## 2. AWS IAM Role

The IAM role enables the EC2 instance to assume identity and access S3 using instance metadata.

### Step 1: Define the Trust Policy

Save the following to a file named `trust-policy.json`:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Principal": {
                "Service": [
                    "ec2.amazonaws.com"
                ]
            }
        }
    ]
}
```

### Step 2: Create the IAM Role

Create the role using the trust policy:

```bash
aws iam create-role --role-name my-ec2-rp-s3-role \
    --assume-role-policy-document file://trust-policy.json
```

### Step 3: Define the Permissions Policy

Save the following to `s3-rw-policy.json`, replacing `my-rp-docker-bucket` with your bucket name:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowListAndLocation",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetBucketLocation"
            ],
            "Resource": "arn:aws:s3:::my-rp-docker-bucket"
        },
        {
            "Sid": "AllowObjectOpsAnywhere",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:GetObjectAcl",
                "s3:GetObjectVersion"
            ],
            "Resource": "arn:aws:s3:::my-rp-docker-bucket/*"
        }
    ]
}
```

### Step 4: Attach the Permissions Policy

Attach the inline policy to the role:

```bash
aws iam put-role-policy --role-name my-ec2-rp-s3-role \
    --policy-name S3AccessPolicy \
    --policy-document file://s3-rw-policy.json
```

## 3. IAM Instance Profile

### Step 1: Create an Instance Profile

```bash
aws iam create-instance-profile --instance-profile-name my-ec2-rp-s3-profile
```

### Step 2: Attach the Role to the Instance Profile

```bash
aws iam add-role-to-instance-profile \
    --instance-profile-name my-ec2-rp-s3-profile \
    --role-name my-ec2-rp-s3-role
```

### Step 3: Associate the Profile with the EC2 Instance

Replace `INSTANCE_ID` with your EC2 instance ID:

```bash
aws ec2 associate-iam-instance-profile \
    --region us-east-1 \
    --instance-id <INSTANCE_ID> \
    --iam-instance-profile Name=my-ec2-rp-s3-profile
```

### Step 4: Enable Instance Metadata Access

To allow a Docker container to access IMDSv2 metadata, you must increase the instance metadata service (IMDS) hop limit in the EC2 instance configuration:

```bash
aws ec2 modify-instance-metadata-options \
    --instance-id <INSTANCE_ID> \
    --http-put-response-hop-limit 2 \
    --http-endpoint enabled \
    --region us-east-1
```
Ref.: [Access instance metadata for an EC2 instance (AWS Docs)](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instancedata-data-retrieval.html)

## 4. ReportPortal Configuration

In your `docker-compose.yml`, configure ReportPortal to use IAM-based S3 access:

```yaml
x-environment: &common-environment
  # IAM Role-Based S3 Access - Leave credentials empty
  DATASTORE_ACCESSKEY: ""
  DATASTORE_SECRETKEY: ""
  DATASTORE_TYPE: s3
  DATASTORE_REGION: us-standard      # JClouds alias for us-east-1
  DATASTORE_DEFAULTBUCKETNAME: my-rp-docker-bucket
```

> For full configuration options, see the [ReportPortal S3 integration guide](https://reportportal.io/docs/installation-steps-advanced/file-storage-options/S3CloudStorage).

## 5. Docker-Based Installation

Launch ReportPortal with Docker Compose:

```bash
docker-compose -p reportportal up -d --force-recreate
```

This step brings up all ReportPortal services configured to use S3 as the storage backend with IAM role-based credentials via EC2 instance metadata.