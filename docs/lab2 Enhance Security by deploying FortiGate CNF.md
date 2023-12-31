# LAB#2: Enhance Security by deploying FortiGate CNF


## Deploy FortigateCNF
In this part of the LAB, we'll setup FortigateCNF to inspect traffic in between both subnets.


![East-West.drawio.png](../images/architecture1-Single-VPC-East-West.drawio.png)


- In AWS marketplace, under "Discover Products", search for **Fortigate CNF** and signup for the trail. <br>
  Use the provided FortiCloud account by your instructor, (You do not need to create one).<br>
  *If your AWS account states that your trail is expired, select the "Public" offer type to set up consumption-based pricing*.<br>
  <br>
![FortiGateCNFonMarketPlace.png](../images/FortiGateCNFonMarketPlace.png)

- Click on "Subscribe", then "Set up your account" at the top of the screen, and follow the steps

![SubscribeToFortiGateCNF.png](../images/SubscribeToFortiGateCNF.png)

- Step#2: Link a new or existing vendor account
Login to FortiCloud / FortiGate CNF
```
student<xx>@kubiosec.tech / Password (check with your instructor)
```

- Step#3 Launch FortiGate CNF CloudFormation template

  this template will deploy the required resources that facilitates the integration between your AWS account(s) and Fortinet AWS account(s) where the FortiGate CNF resides.

- Step 4: Launch FortiGate CNF Follow the instructions to add your AWS Account ID
  
![AWS_account_cft.png](../images/AWS_account_cft.png)

- Create FortiGateCNF Instances and follow the instructions.<br>
  Use `Ireland region - eu-west-1`<br>
  
![add_cnf.png](../images/add_cnf.png)
![endpoints.png](../images/endpoints.png)
![completed_config.png](../images/completed_config.png)

-   When completed, you can find the endpoint name in the AWS console.<br>

![aws_endpoint.png](../images/aws_endpoint.png)

- Reroute traffic to FortiGate CNF
    Two ways to do this:

  1) Manually, through updating the subnets routing table to direct the traffic to the Gateway Load Balancer endpoint; or
  2) Programmatically, through Terraform. We will use this method.
            Return to the Cloud9 environment and make sure your syntax is showing the jumpbox.
            Update the Terraform `variables.tf` with GWLBe name and re-run Terraform.

- Traffic should be routed through Fortigate CNF
  
## Things to try
- ex. allow traffic to port 8080 and block 8090
- Create a dynamic address. Which cloud-native dynamic attribute could be configured under for a dynamic address?
- Add the dynamic address to a firewall policy and test traffic filtering.
- Check subnets routing on AWS console


## Note: 
extra security features (like IPS inspection) requires having FortiManager to manage the FortiGate CNF instance and push the required policies and security profiles. This is out of scope for this lab.


## Cleanup
See [Home](https://github.com/40net-cloud/xpert2023_aws_networking_demystified/blob/xpertsummitbenelux2023/readme.md#:~:text=Environment%20cleanup%20after%20finishing%20all%20labs)
