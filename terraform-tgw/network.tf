##############################################################################################################
#
# FortiGate CNF
# Transit Gateway setup
#
##############################################################################################################
# VPC Inspection
##############################################################################################################
resource "aws_vpc" "vpc-inspection" {
  cidr_block           = var.vpccidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"
  tags = {
    Name = "${var.PREFIX}-vpc-inspection"
  }
}

resource "aws_subnet" "transitsubnetaz1" {
  vpc_id            = aws_vpc.vpc-inspection.id
  cidr_block        = var.attachcidraz1
  availability_zone = local.az1
  tags = {
    Name = "${var.PREFIX}-inspection-transit-subnet-az1"
  }
}

resource "aws_subnet" "transitsubnetaz2" {
  vpc_id            = aws_vpc.vpc-inspection.id
  cidr_block        = var.attachcidraz2
  availability_zone = local.az2
  tags = {
    Name = "${var.PREFIX}-inspection-transit-subnet-az2"
  }
}
resource "aws_subnet" "gwlbsubnetaz1" {
  vpc_id            = aws_vpc.vpc-inspection.id
  cidr_block        = var.gwlbcidraz1
  availability_zone = local.az1
  tags = {
    Name = "${var.PREFIX}-inspection-gwlb-subnet-az1"
  }
}

resource "aws_subnet" "gwlbsubnetaz2" {
  vpc_id            = aws_vpc.vpc-inspection.id
  cidr_block        = var.gwlbcidraz2
  availability_zone = local.az2
  tags = {
    Name = "${var.PREFIX}-inspection-gwlb-subnet-az2"
  }
}

resource "aws_route_table" "transitrtaz1" {
  vpc_id = aws_vpc.vpc-inspection.id

  tags = {
    Name = "${var.PREFIX}-inspection-transit-rt-az1"
  }
}

resource "aws_route" "transitrouteaz1" {
  count                  = var.VPC_ENDPOINT_AZ1 == "" ? 0 : 1
  route_table_id         = aws_route_table.transitrtaz1.id
  destination_cidr_block = "0.0.0.0/0"
  vpc_endpoint_id        = data.aws_vpc_endpoint.gwlbendpointcnfaz1[0].id
}

resource "aws_route_table_association" "transitprivateassociateaz1" {
  subnet_id      = aws_subnet.transitsubnetaz1.id
  route_table_id = aws_route_table.transitrtaz1.id
}

data "aws_vpc_endpoint" "gwlbendpointcnfaz1" {
  count = var.VPC_ENDPOINT_AZ1 == "" ? 0 : 1
  tags = {
    "ManagedBy" : "fwaas"
    "Name" : var.VPC_ENDPOINT_AZ1
  }
}

resource "aws_route_table" "transitrtaz2" {
  vpc_id = aws_vpc.vpc-inspection.id

  tags = {
    Name = "${var.PREFIX}-inspection-transit-rt-az2"
  }
}

resource "aws_route" "transitrouteaz2" {
  count                  = var.VPC_ENDPOINT_AZ2 == "" ? 0 : 1
  route_table_id         = aws_route_table.transitrtaz2.id
  destination_cidr_block = "0.0.0.0/0"
  vpc_endpoint_id        = data.aws_vpc_endpoint.gwlbendpointcnfaz2[0].id
}

resource "aws_route_table_association" "transitprivateassociateaz2" {
  subnet_id      = aws_subnet.transitsubnetaz2.id
  route_table_id = aws_route_table.transitrtaz2.id
}

data "aws_vpc_endpoint" "gwlbendpointcnfaz2" {
  count = var.VPC_ENDPOINT_AZ2 == "" ? 0 : 1
  tags = {
    "ManagedBy" : "fwaas"
    "Name" : var.VPC_ENDPOINT_AZ2
  }
}

resource "aws_route_table" "gwlbrtaz1" {
  vpc_id = aws_vpc.vpc-inspection.id

  tags = {
    Name = "${var.PREFIX}-inspection-gwlb-rt-az1"
  }
}

resource "aws_route" "gwlbroute" {
  route_table_id         = aws_route_table.gwlbrtaz1.id
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id
}

resource "aws_route_table_association" "gwlbprivateassociateaz1" {
  subnet_id      = aws_subnet.gwlbsubnetaz1.id
  route_table_id = aws_route_table.gwlbrtaz1.id
}

resource "aws_route_table" "gwlbrtaz2" {
  vpc_id = aws_vpc.vpc-inspection.id

  tags = {
    Name = "${var.PREFIX}-inspection-gwlb-rt-az2"
  }
}

resource "aws_route" "gwlbrouteaz2" {
  route_table_id         = aws_route_table.gwlbrtaz2.id
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id
}

resource "aws_route_table_association" "gwlbprivateassociateaz2" {
  subnet_id      = aws_subnet.gwlbsubnetaz2.id
  route_table_id = aws_route_table.gwlbrtaz2.id
}

##############################################################################################################
# VPC Spoke 1
##############################################################################################################
resource "aws_vpc" "vpc-spoke1" {
  cidr_block           = var.csvpccidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"
  tags = {
    Name = "${var.PREFIX}-vpc-spoke1"
  }
}

resource "aws_subnet" "spoke1privatesubnetaz1" {
  vpc_id            = aws_vpc.vpc-spoke1.id
  cidr_block        = var.csprivatecidraz1
  availability_zone = local.az1
  tags = {
    Name = "${var.PREFIX}-spoke1-private-subnet-az1"
  }
}

resource "aws_subnet" "spoke1privatesubnetaz2" {
  vpc_id            = aws_vpc.vpc-spoke1.id
  cidr_block        = var.csprivatecidraz2
  availability_zone = local.az2
  tags = {
    Name = "${var.PREFIX}-spoke1-private-subnet-az2"
  }
}

resource "aws_route_table" "spoke1privatert" {
  vpc_id = aws_vpc.vpc-spoke1.id

  tags = {
    Name = "${var.PREFIX}-spoke1-rt"
  }
}

resource "aws_route_table_association" "spoke1privateassociateaz1" {
  subnet_id      = aws_subnet.spoke1privatesubnetaz1.id
  route_table_id = aws_route_table.spoke1privatert.id
}

resource "aws_route_table_association" "spoke1privateassociateaz2" {
  subnet_id      = aws_subnet.spoke1privatesubnetaz2.id
  route_table_id = aws_route_table.spoke1privatert.id
}

resource "aws_route" "spoke1internalroutetgw" {
  depends_on             = [aws_route_table.spoke1privatert]
  route_table_id         = aws_route_table.spoke1privatert.id
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id
}

##############################################################################################################
# VPC Spoke 2
##############################################################################################################
resource "aws_vpc" "vpc-spoke2" {
  cidr_block           = var.cs2vpccidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"
  tags = {
    Name = "${var.PREFIX}-vpc-spoke2"
  }
}

resource "aws_subnet" "spoke2privatesubnetaz1" {
  vpc_id            = aws_vpc.vpc-spoke2.id
  cidr_block        = var.cs2privatecidraz1
  availability_zone = local.az1
  tags = {
    Name = "${var.PREFIX}-spoke2-private-subnet-az1"
  }
}

resource "aws_subnet" "spoke2privatesubnetaz2" {
  vpc_id            = aws_vpc.vpc-spoke2.id
  cidr_block        = var.cs2privatecidraz2
  availability_zone = local.az2
  tags = {
    Name = "${var.PREFIX}-spoke2-private-subnet-az2"
  }
}

resource "aws_route_table" "spoke2privatert" {
  vpc_id = aws_vpc.vpc-spoke2.id

  tags = {
    Name = "${var.PREFIX}-spoke2-rt"
  }
}

resource "aws_route_table_association" "spoke2privateassociateaz1" {
  subnet_id      = aws_subnet.spoke2privatesubnetaz1.id
  route_table_id = aws_route_table.spoke2privatert.id
}

resource "aws_route_table_association" "spoke2privateassociateaz2" {
  subnet_id      = aws_subnet.spoke2privatesubnetaz2.id
  route_table_id = aws_route_table.spoke2privatert.id
}

resource "aws_route" "spoke2internalroutetgw" {
  depends_on             = [aws_route_table.spoke2privatert]
  route_table_id         = aws_route_table.spoke2privatert.id
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id
}

##############################################################################################################
# VPC Spoke egress
##############################################################################################################
resource "aws_eip" "egresspipaz1" {
  vpc = true
  tags = {
    Name = "${var.PREFIX}-spoke-egress-pip-az1"
  }
}

resource "aws_eip" "egresspipaz2" {
  vpc = true
  tags = {
    Name = "${var.PREFIX}-spoke-egress-pip-az2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc-spoke-egress.id
  tags = {
    Name = "${var.PREFIX}-spoke-egress-igw"
  }
}

resource "aws_nat_gateway" "natgw-az1" {
  allocation_id = aws_eip.egresspipaz1.id
  subnet_id     = aws_subnet.egresspublicsubnetaz1.id

  tags = {
    Name = "${var.PREFIX}-spoke-egress-natgw-az1"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "natgw-az2" {
  allocation_id = aws_eip.egresspipaz2.id
  subnet_id     = aws_subnet.egresspublicsubnetaz2.id

  tags = {
    Name = "${var.PREFIX}-spoke-egress-natgw-az2"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}


resource "aws_vpc" "vpc-spoke-egress" {
  cidr_block           = var.egressvpccidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"
  tags = {
    Name = "${var.PREFIX}-vpc-spoke-egress"
  }
}

resource "aws_subnet" "egresspublicsubnetaz1" {
  vpc_id            = aws_vpc.vpc-spoke-egress.id
  cidr_block        = var.egresspubliccidraz1
  availability_zone = local.az1
  tags = {
    Name = "${var.PREFIX}-spoke-egress-public-subnet-az1"
  }
}

resource "aws_subnet" "egresspublicsubnetaz2" {
  vpc_id            = aws_vpc.vpc-spoke-egress.id
  cidr_block        = var.egresspubliccidraz2
  availability_zone = local.az2
  tags = {
    Name = "${var.PREFIX}-spoke-egress-public-subnet-az2"
  }
}

resource "aws_subnet" "egressprivatesubnetaz1" {
  vpc_id            = aws_vpc.vpc-spoke-egress.id
  cidr_block        = var.egressprivatecidraz1
  availability_zone = local.az1
  tags = {
    Name = "${var.PREFIX}-spoke-egress-private-subnet-az1"
  }
}

resource "aws_subnet" "egressprivatesubnetaz2" {
  vpc_id            = aws_vpc.vpc-spoke-egress.id
  cidr_block        = var.egressprivatecidraz2
  availability_zone = local.az2
  tags = {
    Name = "${var.PREFIX}-spoke-egress-private-subnet-az2"
  }
}

resource "aws_route_table" "egressprivatertaz1" {
  vpc_id = aws_vpc.vpc-spoke-egress.id

  tags = {
    Name = "${var.PREFIX}-spoke-egress-private-rt-az1"
  }
}

resource "aws_route_table" "egressprivatertaz2" {
  vpc_id = aws_vpc.vpc-spoke-egress.id

  tags = {
    Name = "${var.PREFIX}-spoke-egress-private-rt-az2"
  }
}

resource "aws_route_table" "egresspublicrtaz1" {
  vpc_id     = aws_vpc.vpc-spoke-egress.id

  tags = {
    Name = "${var.PREFIX}-spoke-egress-public-rt-az1"
  }
}

resource "aws_route_table" "egresspublicrtaz2" {
  vpc_id     = aws_vpc.vpc-spoke-egress.id

  tags = {
    Name = "${var.PREFIX}-spoke-egress-public-rt-az2"
  }
}

resource "aws_route_table_association" "egresspublicassociateaz1" {
  subnet_id      = aws_subnet.egresspublicsubnetaz1.id
  route_table_id = aws_route_table.egresspublicrtaz1.id
}

resource "aws_route_table_association" "egresspublicassociateaz2" {
  subnet_id      = aws_subnet.egresspublicsubnetaz2.id
  route_table_id = aws_route_table.egresspublicrtaz2.id
}

resource "aws_route_table_association" "egressprivateassociateaz1" {
  subnet_id      = aws_subnet.egressprivatesubnetaz1.id
  route_table_id = aws_route_table.egressprivatertaz1.id
}

resource "aws_route_table_association" "egressprivateassociateaz2" {
  subnet_id      = aws_subnet.egressprivatesubnetaz2.id
  route_table_id = aws_route_table.egressprivatertaz2.id
}

resource "aws_route" "egressinternalroutetgwaz1" {
  depends_on             = [aws_route_table.egressprivatertaz1]
  route_table_id         = aws_route_table.egressprivatertaz1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.natgw-az1.id
}

##added to fix
resource "aws_route" "egressinternalroutetgwaz1-tgw" {
  depends_on             = [aws_route_table.egressprivatertaz1]
  route_table_id         = aws_route_table.egressprivatertaz1.id
  destination_cidr_block = "10.0.0.0/8"
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id
}



resource "aws_route" "egressinternalroutetgwaz2" {
  depends_on             = [aws_route_table.egressprivatertaz2]
  route_table_id         = aws_route_table.egressprivatertaz2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.natgw-az2.id
}

## added
resource "aws_route" "egressinternalroutetgwaz2-tgw" {
  depends_on             = [aws_route_table.egressprivatertaz2]
  route_table_id         = aws_route_table.egressprivatertaz2.id
  destination_cidr_block = "10.0.0.0/8"
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id
}


resource "aws_route" "egresspublicroutetgwaz1" {
  depends_on             = [aws_route_table.egresspublicrtaz1]
  route_table_id         = aws_route_table.egresspublicrtaz1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route" "egresspublicroutetgwaz2" {
  depends_on             = [aws_route_table.egresspublicrtaz2]
  route_table_id         = aws_route_table.egresspublicrtaz2.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route" "egresspublicroutetgwaz1-tgw" {
  depends_on             = [aws_route_table.egresspublicrtaz1]
  route_table_id         = aws_route_table.egresspublicrtaz1.id
  destination_cidr_block = "10.0.0.0/8"
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id
}

resource "aws_route" "egresspublicroutetgwaz2-tgw" {
  depends_on             = [aws_route_table.egresspublicrtaz2]
  route_table_id         = aws_route_table.egresspublicrtaz2.id
  destination_cidr_block = "10.0.0.0/8"
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id
}

##############################################################################################################
# VPC Security Groups
##############################################################################################################
resource "aws_security_group" "public_allow" {
  name        = "Public Allow"
  description = "Public Allow traffic"
  vpc_id      = aws_vpc.vpc-inspection.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.PREFIX}-sg-public-allow"
  }
}

resource "aws_security_group" "allow_all" {
  name        = "Allow All"
  description = "Allow all traffic"
  vpc_id      = aws_vpc.vpc-inspection.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.PREFIX}-sg-allow-all"
  }
}

resource "aws_security_group" "spoke1_allow_all" {
  name        = "Spoke1 Allow All"
  description = "Allow all traffic"
  vpc_id      = aws_vpc.vpc-spoke1.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.PREFIX}-sg-spoke1-allow-all"
  }
}

resource "aws_security_group" "spoke2_allow_all" {
  name        = "Spoke2 Allow All"
  description = "Allow all traffic"
  vpc_id      = aws_vpc.vpc-spoke2.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.PREFIX}-sg-spoke2-allow-all"
  }
}

