# LAB 2: transit gateway centralised inspection use-case

## Deploy the environment
Inside the cloned repo:
```
cd ./xpert2023_aws_networking_demystified/terraform-tgw
```
```
terraform init
terraform apply
```
Extract the private SSH key
```
terraform output -raw private_key >key.pem
chmod 400 key.pem
```
Access your Jumpbox
```
ssh -i ./key.pem ubuntu@<jumpbox>
```
You can use this key to access all the other hosts in the labs. Simply copy the key and set the correct permissions.

## Deploy fortigatecnf
- Install / verify cross account setup
- Deploy fortigatecnf and endpoints
- Update the TF script with GWLBe and re-run TF
- Test connectivity

## Create a policy set
- checkout the routing

## Cleanup
See [Home](./readme.md)


