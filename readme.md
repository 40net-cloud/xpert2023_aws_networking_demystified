## FortigateCNF Hands-on Lab

## 1. Verify Access
### AWS Console Login
Access the AWS console using this URL: [https://aws.amazon.com/console/](https://aws.amazon.com/console/)
```
AccountID / IAM user name / Password (check with your instructor)
```
### FortiCloud / FortigateCNF Login
```
student<xx>@kubiosec.tech / Password (check with your instructor)
```

## 2. Prepare a LAB environment
<img src=".\images\management-access.png">

### Cloud9 AWS environment
Use region `eu-west-1` (ireland) <br>
Create an AWS Cloud9 instance.

### AWS access-key and secret-key
An AWS_ACCESS_KEY and AWS_SECRET_KEY is already created (check with your instructor)

### Subscribe to the ubuntu-jammy AMI
Goto [https://aws.amazon.com/marketplace/pp?sku=4s6b2r2vfe46kyul508kf459f](https://aws.amazon.com/marketplace/pp?sku=4s6b2r2vfe46kyul508kf459f) and subscribe and accept the terms.

### Clone the LAB repo 
Clone following repo in `/environment` in your Cloud9 env
```
git clone https://github.com/40net-cloud/xpert2023_aws_networking_demystified.git
```
## LAB#1: Deploy a FortigateCNF playground for intra-subnet / single VPC
See [lab1](./docs/lab1.md)

## Cleanup 
At the end of our session destroy all environments: 
- remove the endpoints form your TF `variables.tf`
- re-run your TF `terraform apply`
- remove all Fortigate CNF instancesfrom the Fortigate CNF UI
- destroy your terraform infra `terraform destroy`
- remove all registered accounts from the Fortigate CNF UI
- remove cloudformation `FortinetFWaaSCrossAccountSetup` from AWS region `Oregon`
- remove your Cloud9 instance

Thank you, the next student will thank you as well as the instructor who knows your name ;-)
