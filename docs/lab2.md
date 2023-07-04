# LAB#2: Transit Gateway (TGW) Centralised Inspection Use-case

## Deploy the environment
Inside the cloned repo:
```
cd ./xpert2023_aws_networking_demystified/terraform-tgw
```
```
terraform init
terraform apply
```
Extract the private SSH-key
```
terraform output -raw private_key >key.pem
chmod 400 key.pem
```
Access your Jumpbox
```
ssh -i ./key.pem ubuntu@<jumpbox>
```
You can use this key to access all the other hosts in the labs. Simply copy the key and set the correct permissions.

## Deploy FortiGateCNF
- Install / verify cross account setup
- Deploy FortiGateCNF and endpoints
- Update the Terraform script with GWLBe and re-run TF
- Test connectivity

## Create a policy set
- Check the routing

## Cleanup
See [Home](./readme.md)


