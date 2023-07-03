## Fortigate CNF lab

## 1. Verify access
### AWS Console
```
account_id / studentcnp / <see your instructor>
```
### Forticloud / FortigateCNF
```
student<xx>@kubiosec.tech / <see your instructor>
```

## 2. Prepare a LAB environment
### Cloud9 AWS environment
Use region `eu-west-1` (ireland) <br>
Create an AWS Cloud9 instance.

### Create an AWS access key and secret
Login the AWS console and create an **access key** and **secret** under the IAM user `studentcnp`<br>
Note the access key and secret.

### Subscribe to the ubuntu-jammy
Goto `https://aws.amazon.com/marketplace/pp?sku=47xbqns9xujfkkjt189a13aqe` and subscribe and accept the terms.

### Clone the LAB repo 
Clone following repo in `/environment` in your Cloud9 env
```
git clone https://github.com/40net-cloud/fortigate-cnf-sse-workshop.git
```

## LAB 1: Deploy a fortigatecnf playground for intra-subnet / single vpc
See [lab1](./lab1.md)

## LAB 2: Deploy a fortigatecnf playground fortransit gateway use-case
See [lab2](./lab2.md)

### CLEANUP 
At the end of our session: 
- remove the endpoints form your TF `variables.tf`
- re-run your TF
- destroy your terraform infra
- remove all Fortigate CNF instancesfrom the Fortigate CNF UI
- remove all registered accounts from the Fortigate CNF UI
- remove cloudformation `FortinetFWaaSCrossAccountSetup` from AWS region `Oregon`
- remove the access key and secret (NOT the IAM user !!)
- remove your Cloud9 instance

Thx, the next student will thank you as well as the instructor who knows your name ;-)
