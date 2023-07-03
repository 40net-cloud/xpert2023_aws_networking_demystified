##############################################################################################################
#
# FortiGate CNF
# Transit Gateway setup
#
##############################################################################################################

# Prefix for all resources created for this deployment in Microsoft Azure
variable "PREFIX" {
  description = "Added name to each deployed resource"
  default = "cnflab"
}

variable "environment" {
  default = "dev"
  description = "The name of the environment."
 }
 
variable "REGION" {
  description = "AWS region"
  default = "eu-west-1"
}

variable "USERNAME" {
  description = "Default username for FortiGate-VM in AWS is admin"
  default     = "admin"
}

variable "PASSWORD" {
  description = "Default password for admin user is the instance id"
  default     = ""
}

//AWS Configuration
variable "ACCESS_KEY" {}
variable "SECRET_KEY" {}

//  Existing SSH Key on the AWS
variable "KEY_PAIR" {
  default = ""
}

variable "VPC_ENDPOINT_AZ1" {
 #default = "prod-c2116-s179442-endpoint-subnet-0ab390c9002a2ae06"
 default = ""
  
}

variable "VPC_ENDPOINT_AZ2" {
  #default = "prod-c2116-s179442-endpoint-subnet-0552c79eee8bdbd46"
  default = ""
}

// Availability zones for the region
locals {
  az1 = "${var.REGION}a"
  az2 = "${var.REGION}b"
}

data "aws_ami" "lnx_ami" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

variable "lnx_vmsize" {
  default = "t4g.micro"
}

##############################################################################################################
# Static variables
##############################################################################################################

// VPC for Inspection VPC
variable "vpccidr" {
  default = "10.1.0.0/16"
}

variable "publiccidraz1" {
  default = "10.1.0.0/24"
}

variable "privatecidraz1" {
  default = "10.1.1.0/24"
}

variable "attachcidraz1" {
  default = "10.1.2.0/24"
}

variable "gwlbcidraz1" {
  default = "10.1.3.0/24"
}

variable "publiccidraz2" {
  default = "10.1.4.0/24"
}

variable "privatecidraz2" {
  default = "10.1.5.0/24"
}

variable "attachcidraz2" {
  default = "10.1.6.0/24"
}

variable "gwlbcidraz2" {
  default = "10.1.7.0/24"
}

// VPC for VPC Spoke1
variable "csvpccidr" {
  default = "10.2.0.0/16"
}

variable "cspubliccidraz1" {
  default = "10.2.0.0/24"
}

variable "csprivatecidraz1" {
  default = "10.2.1.0/24"
}

variable "cspubliccidraz2" {
  default = "10.2.2.0/24"
}

variable "csprivatecidraz2" {
  default = "10.2.3.0/24"
}

// VPC for VPC Spoke2
variable "cs2vpccidr" {
  default = "10.3.0.0/16"
}

variable "cs2publiccidraz1" {
  default = "10.3.0.0/24"
}

variable "cs2privatecidraz1" {
  default = "10.3.1.0/24"
}

variable "cs2publiccidraz2" {
  default = "10.3.2.0/24"
}

variable "cs2privatecidraz2" {
  default = "10.3.3.0/24"
}

// VPC for VPC Egress
variable "egressvpccidr" {
  default = "10.254.0.0/16"
}

variable "egresspubliccidraz1" {
  default = "10.254.0.0/24"
}

variable "egressprivatecidraz1" {
  default = "10.254.1.0/24"
}

variable "egresspubliccidraz2" {
  default = "10.254.2.0/24"
}

variable "egressprivatecidraz2" {
  default = "10.254.3.0/24"
}

variable "fortinet_tags" {
  type = map(string)
  default = {
    publisher : "Fortinet",
    template : "IPSEC-tunnels",
    provider : "7EB3B02F-50E5-4A3E-8CB8-2E129258IPSECTUNNELS"
  }
}
