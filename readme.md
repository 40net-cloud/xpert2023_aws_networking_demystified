## Fortigate CNF lab

## 1. Verify access
### AWS Console
Access the AWS console Access the AWS console [https://aws.amazon.com/console/](https://aws.amazon.com/console/)
```
AccountID / IAM user name / Password (see your instructor)
```
### Forticloud / FortigateCNF
```
student<xx>@kubiosec.tech / Password (see your instructor)
```

## 2. Prepare a LAB environment
<img src=".\images\management-access.png">

### Cloud9 AWS environment
Use region `eu-west-1` (ireland) <br>
Create an AWS Cloud9 instance.

### AWS access key and secret
An AWS_ACCESS_KEY and AWS_SECRET_KEY is already created (see your instructor)

### Subscribe to the ubuntu-jammy
Goto [https://aws.amazon.com/marketplace/pp?sku=4s6b2r2vfe46kyul508kf459f](https://aws.amazon.com/marketplace/pp?sku=4s6b2r2vfe46kyul508kf459f) and subscribe and accept the terms.

### Clone the LAB repo 
Clone following repo in `/environment` in your Cloud9 env
```
git clone https://github.com/40net-cloud/xpert2023_aws_networking_demystified.git
```
## LAB 1: Deploy a fortigatecnf playground for intra-subnet / single vpc
See [lab1](./docs/lab1.md)

## LAB 2: Deploy a fortigatecnf playground fortransit gateway use-case
See [lab2](./docs/lab2.md)

### CLEANUP 
At the end of our session: 
- remove the endpoints form your TF `variables.tf`
- re-run your TF `terraform apply`
- remove all Fortigate CNF instancesfrom the Fortigate CNF UI
- destroy your terraform infra `terraform destroy`
- remove all registered accounts from the Fortigate CNF UI
- remove cloudformation `FortinetFWaaSCrossAccountSetup` from AWS region `Oregon`
- remove the access key and secret (NOT the IAM user !!)
- remove your Cloud9 instance

Thx, the next student will thank you as well as the instructor who knows your name ;-)
