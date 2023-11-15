## FortigateCNF Hands-on Lab

## 1. Verify Access
### AWS Console Login
Access the AWS console using this URL: [AWS Console Login](https://aws.amazon.com/console/)
```
AccountID / IAM user name / Password (check with your instructor)
```

## 2. In Lab 1, we will prepare the following LAB environment
<img src=".\images\management-access.png">

### Cloud9 AWS environment
Use region `eu-west-1` (ireland) <br>
Create an AWS Cloud9 instance: 
- Instance type: t2.micro
- Platform: Amazon Linux 2
- Timeout: 30 minutes
- Connection: AWS Systems Manager (SSM)
- VPC Settings: keep default value

### AWS access-key and secret-key
An AWS_ACCESS_KEY and AWS_SECRET_KEY is already created (check with your instructor)

### Subscribe to the EC2 AMIon AWS Marketplace
Go to ["Minimal Ubuntu 22.04 LTS - Jammy" AMI](https://aws.amazon.com/marketplace/pp?sku=4s6b2r2vfe46kyul508kf459f) to subscribe and accept the terms.

### Access the Cloud9 instance, and clone the LAB repo 
Clone following repo in `/environment` in your Cloud9 env
```
git clone https://github.com/40net-cloud/xpert2023_aws_networking_demystified.git
```
## LAB#2: Lab Setup: Intra-Subnet / Single-VPC Use-case
See [Lab1](https://github.com/40net-cloud/xpert2023_aws_networking_demystified/blob/xpertsummitbenelux2023/docs/lab1%20Lab%20Setup.md)


## Environment cleanup after finishing all labs
At the end of our session destroy all environments: 
- remove the endpoints form your TF `variables.tf`
- re-run your TF `terraform apply`
- remove all Fortigate CNF instancesfrom the Fortigate CNF UI
- destroy your terraform infra `terraform destroy`
- remove all registered accounts from the Fortigate CNF UI (wait until the CNF instance is deleted from the "CNF Instances" tab ... this can take few minutes)
- remove the cloudformation template 'FortinetForigateStackName' from AWS region eu-west-1 (Ireland)
- delete your Cloud9 instance

Thank you, the next student will thank you as well as the instructor who knows your name ;-)
