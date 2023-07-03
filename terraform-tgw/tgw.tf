##############################################################################################################
#
# FortiGate CNF
# Transit Gateway setup
#
##############################################################################################################
# Transit Gateway
##############################################################################################################
resource "aws_ec2_transit_gateway" "tgw" {
  description                     = "Transit Gateway with 3 VPCs"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  tags = {
    Name = "${var.PREFIX}-tgw"
  }
}

##############################################################################################################
# Transit Gateway
##############################################################################################################
# Route Table - FGT VPC
resource "aws_ec2_transit_gateway_route_table" "tgw-from-inspection-route" {
  depends_on         = [aws_ec2_transit_gateway.tgw]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  tags = {
    Name = "${var.PREFIX}-tgw-from-inspection-rt"
  }
}

# Route Table - Spoke1 VPC
resource "aws_ec2_transit_gateway_route_table" "tgw-from-spoke-route" {
  depends_on         = [aws_ec2_transit_gateway.tgw]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  tags = {
    Name = "${var.PREFIX}-tgw-from-spoke-rt"
  }
}

##############################################################################################################
# Inspection VPC attachment, associations, propagations
##############################################################################################################
# VPC attachment - Inspection VPC
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-att-vpc-inspection" {
  appliance_mode_support                          = "enable"
  subnet_ids                                      = [aws_subnet.transitsubnetaz1.id, aws_subnet.transitsubnetaz2.id]
  transit_gateway_id                              = aws_ec2_transit_gateway.tgw.id
  vpc_id                                          = aws_vpc.vpc-inspection.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name = "${var.PREFIX}-vpc-inspection-vpc-attachment"
  }
  depends_on = [aws_ec2_transit_gateway.tgw]
}

# Route Tables Associations - FGT VPC
resource "aws_ec2_transit_gateway_route_table_association" "tgw-rt-vpc-fgt-assoc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att-vpc-inspection.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-from-inspection-route.id
}

# Route Tables Propagations - Spoke1 VPC Route
resource "aws_ec2_transit_gateway_route_table_propagation" "tgw-rt-prop-cs-w-fgt" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att-vpc-inspection.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-from-spoke-route.id
}

##############################################################################################################
# Egress VPC attachment, associations, propagations
##############################################################################################################
# VPC attachment - Spoke egress VPC
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-att-vpc-egress" {
  appliance_mode_support                          = "enable"
  subnet_ids                                      = [aws_subnet.egressprivatesubnetaz1.id, aws_subnet.egressprivatesubnetaz2.id]
  transit_gateway_id                              = aws_ec2_transit_gateway.tgw.id
  vpc_id                                          = aws_vpc.vpc-spoke-egress.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name = "${var.PREFIX}-vpc-egress-vpc-attachment"
  }
  depends_on = [aws_ec2_transit_gateway.tgw]
}

# Route Tables Associations - Spoke egress VPC
## fixed
resource "aws_ec2_transit_gateway_route_table_association" "tgw-rt-vpc-egress-assoc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att-vpc-egress.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-from-spoke-route.id
}

## Route Tables Propagations - FGT VPC2 Route
#resource "aws_ec2_transit_gateway_route_table_propagation" "tgw-rt-prop-fgt-w-egress" {
#  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att-vpc-egress.id
#  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-from-inspection-route.id
#}

##############################################################################################################
# Spoke 1 VPC attachment, associations, propagations
##############################################################################################################
# VPC attachment - Spoke1 VPC
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-att-vpc-spoke1" {
  appliance_mode_support                          = "enable"
  subnet_ids                                      = [aws_subnet.spoke1privatesubnetaz1.id, aws_subnet.spoke1privatesubnetaz2.id]
  transit_gateway_id                              = aws_ec2_transit_gateway.tgw.id
  vpc_id                                          = aws_vpc.vpc-spoke1.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name = "${var.PREFIX}-vpc-spoke1-vpc-attachment"
  }
  depends_on = [aws_ec2_transit_gateway.tgw]
}

# Route Tables Associations - Spoke1 VPC
resource "aws_ec2_transit_gateway_route_table_association" "tgw-rt-vpc-customer-assoc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att-vpc-spoke1.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-from-spoke-route.id
}

# Route Tables Propagations - FGT VPC Route
resource "aws_ec2_transit_gateway_route_table_propagation" "tgw-rt-prop-fgt-w-cs" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att-vpc-spoke1.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-from-inspection-route.id
}

##############################################################################################################
# Spoke 2 VPC attachment, associations, propagations
##############################################################################################################
# VPC attachment - Spoke2 VPC
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-att-vpc-spoke2" {
  appliance_mode_support                          = "enable"
  subnet_ids                                      = [aws_subnet.spoke2privatesubnetaz1.id, aws_subnet.spoke2privatesubnetaz2.id]
  transit_gateway_id                              = aws_ec2_transit_gateway.tgw.id
  vpc_id                                          = aws_vpc.vpc-spoke2.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name = "${var.PREFIX}-vpc-spoke2-vpc-attachment"
  }
  depends_on = [aws_ec2_transit_gateway.tgw]
}

# Route Tables Associations - Spoke2 VPC
resource "aws_ec2_transit_gateway_route_table_association" "tgw-rt-vpc-customer2-assoc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att-vpc-spoke2.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-from-spoke-route.id
}

# Route Tables Propagations - FGT VPC2 Route
resource "aws_ec2_transit_gateway_route_table_propagation" "tgw-rt-prop-fgt-w-cs2" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att-vpc-spoke2.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-from-inspection-route.id
}

##############################################################################################################
# Additional routes
##############################################################################################################
# TGW Route - Spoke1 VPC
resource "aws_ec2_transit_gateway_route" "customer-default-route" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = (var.VPC_ENDPOINT_AZ1 == "" || var.VPC_ENDPOINT_AZ2 == "") ? aws_ec2_transit_gateway_vpc_attachment.tgw-att-vpc-egress.id : aws_ec2_transit_gateway_vpc_attachment.tgw-att-vpc-inspection.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-from-spoke-route.id
}

resource "aws_ec2_transit_gateway_route" "route-to-egress" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att-vpc-egress.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-from-inspection-route.id
}
