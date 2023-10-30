# LAB#2: Enhance Security by deploying FortiGate CNF


## Deploy FortigateCNF
In this part of the LAB, we'll setup FortigateCNF to inspect traffic in between both subnets.


![East-West.drawio.png](../images/architecture1-Single-VPC-East-West.drawio.png)


- In AWS marketplace, under "Discover Products", search for **Fortigate CNF** and signup for the trail. <br>
  Use the provided FortiCloud account by your instructor, (You do not need to create one).<br>
  *If your AWS account states that your trail is expired, select the "Public" offer type to set up consumption-based pricing*.<br>
  <br>
![FortiGateCNFonMarketPlace.png](../images/FortiGateCNFonMarketPlace.png)

- Follow the instructions to add your AWS Account ID
  
![AWS_account_cft.png](../images/AWS_account_cft.png)

- Create FortiGateCNF Instances and follow the instructions.<br>
  Use `Ireland region - eu-west-1`<br>
  
![add_cnf.png](../images/add_cnf.png)
![endpoints.png](../images/endpoints.png)
![completed_config.png](../images/completed_config.png)

-   When completed, you can find the endpoint name in the AWS console.<br>
    Update the Terraform `variables.tf` with GWLBe name and re-run Terraform.

![aws_endpoint.png](../images/aws_endpoint.png)

- Traffic should be routed through Fortigate CNF
  
## Things to try
- ex. allow traffic to port 8080 and block 8090
- Create a dynamic address group
- Chec the routing
- ...






## Cleanup
See [Home](./readme.md)


