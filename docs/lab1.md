# LAB 1: intra-subnet single vpc use case

## Deploy the environment
Inside the cloned repo:
```
cd ./xpert2023_aws_networking_demystified/terraform-single-vpc
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
Access your Jumpbox from your Cloud9 IDE
```
ssh -i ./key.pem ubuntu@<jumpbox>
```
You can use this key to access all the other hosts in the labs. Simply copy the key and set the correct permissions.
```
scp -i key.pem ./key.pem ubuntu@<jumpbox>:key.pem
```
## Test connectivity
<img src="..\images\flow_diagram.png">

## Deploy fortigatecnf
- Install / verify cross account setup
- Deploy fortigatecnf and endpoints
- Test connectivity
- Update the TF script with GWLBe and re-run TF
- Test connectivity

## Things to try
- ex. allow traffic to port 8080 and block 8090
- create a dynamic address group
- checkout the routing
- ...

## Cleanup for next lab
- remove GWLBe from TF `variables.tf` and re-run TF
- remove endpoint form Fortigate CNF UI
- Destroy playground


