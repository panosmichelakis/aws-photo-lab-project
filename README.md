# AWS Photo Lab

A small hands-on AWS project using Terraform. Upload a file to S3 under `incoming/`, an S3 event triggers a Lambda that copies it to `processed/` and writes metadata to DynamoDB. A private EC2 instance (behind a public ALB) serves a small HTTP API to list items and generate presigned URLs.

## Architecture
- VPC with two public subnets (ALB requirement) and one private subnet (EC2)
- No NAT Gateway to keep costs down
- VPC Gateway Endpoints for S3 and DynamoDB
- S3 bucket for uploads (incoming/) and processed outputs (processed/)
- Lambda (outside VPC) triggered by S3 events, writes metadata to DynamoDB
- DynamoDB table for metadata (partition key: `object_key`)
- Public ALB -> private EC2 API on port 8000

Note: The ALB requires two public subnets in different AZs, while the EC2 instance stays in a single private subnet. The EC2 API uses a minimal Python stdlib HTTP server and shells out to the AWS CLI to avoid pip installs in a private subnet without NAT.

## Prerequisites
- Terraform >= 1.5.0
- AWS credentials with permissions for VPC, EC2, ALB, S3, DynamoDB, Lambda, IAM
- Remote state already configured in `infra/environments/dev/backend.tf`

## Deploy
```bash
export AWS_PROFILE=aws-photo-lab
export AWS_REGION=eu-central-1

cd infra/environments/dev
terraform init
terraform apply
```

## Test
1) Upload a file to the `incoming/` prefix:
```bash
aws s3 cp sample.jpg s3://<data_bucket_name>/incoming/sample.jpg
```

2) List items via the ALB:
```bash
curl http://<alb_dns_name>/items
```

3) Get a presigned URL for a processed object. The `object_key` stored in DynamoDB is the processed key (for example, `processed/sample.jpg`):
```bash
curl http://<alb_dns_name>/items/processed/sample.jpg
```

## Teardown
```bash
cd infra/environments/dev
terraform destroy
```
