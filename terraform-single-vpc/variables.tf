variable "aws_access_key" {
description = "The AWS access key."
}

variable "aws_secret_key" {
description = "The AWS access secret."
}

variable "region" {
description = "The AWS region."
default = "eu-west-1"
}

variable "prefix" {
  default = "fortigatecnf"
  description = "The name of our org, i.e. examplecom."
  }

variable "environment" {
  default = "dev"
  description = "The name of the environment."
 }
variable "CNF-ENDPOINT" {
  default = ""
}
