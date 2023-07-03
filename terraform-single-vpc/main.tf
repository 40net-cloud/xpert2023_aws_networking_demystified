# Create a VPC
resource "aws_vpc" "main" {
  cidr_block       = "10.1.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"
  tags = {
    Name = "${var.prefix}-${var.environment}-vpc-iaac"
  }
}

# Create a public subnet-1
resource "aws_subnet" "subnet-public-1" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.1.1.0/24"
    map_public_ip_on_launch = "true" //it makes this a public subnet
    availability_zone = "${var.region}a"
    tags = {
        Name = "${var.prefix}-${var.environment}-subnet-cnf-demo-1"
    }
}

# Create a public subnet-2
resource "aws_subnet" "subnet-public-2" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.1.99.0/24"
    map_public_ip_on_launch = "true" //it makes this a public subnet
    availability_zone = "${var.region}a"
    tags = {
        Name = "${var.prefix}-${var.environment}-subnet-cnf-egress"
    }
}

# Create a public subnet-3

# Create a public subnet-4

# Create a private subnet-5
resource "aws_subnet" "subnet-private-5" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.1.2.0/24"
    map_public_ip_on_launch = "false" //it makes this a private subnet
    availability_zone = "${var.region}a"
    tags = {
        Name = "${var.prefix}-${var.environment}-subnet-cnf-demo-2"
    }
}

# Create a private subnet-6
resource "aws_subnet" "subnet-private-6" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.1.88.0/24"
    map_public_ip_on_launch = "false" //it makes this a private subnet
    availability_zone = "${var.region}a"
    tags = {
        Name = "${var.prefix}-${var.environment}-subnet-cnf-demo-3"
    }
}

# Create a private subnet-7
resource "aws_subnet" "subnet-private-7" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.1.32.0/24"
    map_public_ip_on_launch = "false" //it makes this a private subnet
    availability_zone = "${var.region}b"
    tags = {
        Name = "${var.prefix}-${var.environment}-subnet-cnf-demo-32"
    }
}

# Create a private subnet-8
resource "aws_subnet" "subnet-private-8" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.1.33.0/24"
    map_public_ip_on_launch = "false" //it makes this a private subnet
    availability_zone = "${var.region}b"
    tags = {
        Name = "${var.prefix}-${var.environment}-subnet-cnf-demo-33"
    }
}

# Create a private subnet-9
resource "aws_subnet" "subnet-private-9" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.1.98.0/24"
    map_public_ip_on_launch = "false" //it makes this a private subnet
    availability_zone = "${var.region}b"
    tags = {
        Name = "${var.prefix}-${var.environment}-subnet-cnf-endpoints"
        fortigatecnf_subnet_type = "endpoint"
    }
}

# Create an internet gateway
resource "aws_internet_gateway" "ig-main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.prefix}-${var.environment}-igw"
  }
}

# Create an EIP for NAT gateway
resource "aws_eip" "nat_gateway" {
  vpc = true
  tags = {
    Name = "${var.prefix}-${var.environment}-nat-eip"
  }
}

# Create the NAT gateway
resource "aws_nat_gateway" "natgw-main" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id = aws_subnet.subnet-public-2.id
  tags = {
    Name = "${var.prefix}-${var.environment}-nat-gateway"
  }
}

################################################################################
########## Creating Route Tables ###############################################
################################################################################

# Create an aws route in the main routing table
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.main.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig-main.id
}

# Create a RT for egress network
resource "aws_route_table" "egress-rt" {
  vpc_id = aws_vpc.main.id
    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig-main.id
  }
   tags = {
    Name = "${var.prefix}-${var.environment}-internal"
  }
}

# Create a RT CNF Endpoints
resource "aws_route_table" "endpoint-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgw-main.id
  }
  tags = {
    Name = "${var.prefix}-${var.environment}-endpoint-rt"
  }
}

# Create a RT for internal networks without CNF
resource "aws_route_table" "internal" {
  vpc_id = aws_vpc.main.id
    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgw-main.id
  }
  tags = {
    Name = "${var.prefix}-${var.environment}-internal"
  }
}

################################################################################
########## Creating Dynamic  Route Table  ######################################
################################################################################
# Getting the GWLB endpoint
data "aws_vpc_endpoint" "gwlbendpointcnf" {
  count = var.CNF-ENDPOINT == "" ? 0 : 1
  tags = {
    "ManagedBy" : "fwaas"
    "Name" : var.CNF-ENDPOINT
  }
}
################################################################################
# Create a RT for internal networks with endpoints
################################################################################
resource "aws_route" "CNF-ROUTE-DEFAULT" {
  count = var.CNF-ENDPOINT == "" ? 0 : 1
  route_table_id = aws_route_table.internal-cnf.id
  destination_cidr_block = "0.0.0.0/0"
  vpc_endpoint_id = data.aws_vpc_endpoint.gwlbendpointcnf[0].id
}

resource "aws_route" "CNF-ROUTE-DEFAULT-10-1-2" {
  count = var.CNF-ENDPOINT == "" ? 0 : 1
  route_table_id = aws_route_table.internal-cnf.id
  destination_cidr_block = "10.1.2.0/24"
  vpc_endpoint_id = data.aws_vpc_endpoint.gwlbendpointcnf[0].id
}

resource "aws_route" "CNF-ROUTE-DEFAULT-10-1-88" {
  count = var.CNF-ENDPOINT == "" ? 0 : 1
  route_table_id = aws_route_table.internal-cnf.id
  destination_cidr_block = "10.1.88.0/24"
  vpc_endpoint_id = data.aws_vpc_endpoint.gwlbendpointcnf[0].id
}

resource "aws_route_table" "internal-cnf" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.prefix}-${var.environment}-internal-cnf"
  }
}

################################################################################
# Create a RT for egress network
################################################################################
resource "aws_route" "CNF-ROUTE-DEFAULT-EGRESS" {
  count = var.CNF-ENDPOINT == "" ? 0 : 1
  route_table_id = aws_route_table.egress-cnf.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.ig-main.id
}

resource "aws_route" "CNF-ROUTE-10-1-2-EGRESS" {
  count = var.CNF-ENDPOINT == "" ? 0 : 1
  route_table_id = aws_route_table.egress-cnf.id
  destination_cidr_block = "10.1.2.0/24"
  vpc_endpoint_id = data.aws_vpc_endpoint.gwlbendpointcnf[0].id
}

## ---- need to unset the endppint, change the name and set endpoint again after dynamic route for egress 
resource "aws_route" "CNF-ROUTE-10-1-88-EGRESS" {
  count = var.CNF-ENDPOINT == "" ? 0 : 1
  route_table_id = aws_route_table.egress-cnf.id
  destination_cidr_block = "10.1.88.0/24"
  vpc_endpoint_id = data.aws_vpc_endpoint.gwlbendpointcnf[0].id
}

resource "aws_route_table" "egress-cnf" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.prefix}-${var.environment}-egress-cnf"
  }
}


################################################################################
########## Creating Route Table Associations ###################################
################################################################################

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-private-5.id
  route_table_id = var.CNF-ENDPOINT == "" ? aws_route_table.internal.id : aws_route_table.internal-cnf.id
  # route_table_id = aws_route_table.internal.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.subnet-private-6.id
  route_table_id = var.CNF-ENDPOINT == "" ? aws_route_table.internal.id : aws_route_table.internal-cnf.id
}

resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.subnet-private-7.id
  route_table_id = var.CNF-ENDPOINT == "" ? aws_route_table.internal.id : aws_route_table.internal-cnf.id
}

resource "aws_route_table_association" "d" {
  subnet_id      = aws_subnet.subnet-private-8.id
  route_table_id = var.CNF-ENDPOINT == "" ? aws_route_table.internal.id : aws_route_table.internal-cnf.id
}

resource "aws_route_table_association" "e" {
  subnet_id      = aws_subnet.subnet-private-9.id
  route_table_id = aws_route_table.endpoint-rt.id
}

resource "aws_route_table_association" "f" {
  subnet_id      = aws_subnet.subnet-public-2.id
  route_table_id = var.CNF-ENDPOINT == "" ? aws_route_table.egress-rt.id : aws_route_table.egress-cnf.id

}
resource "aws_default_route_table" "example" {
  default_route_table_id = aws_vpc.main.main_route_table_id
  tags = {
    Name = "${var.prefix}-${var.environment}-default-rtb"
  }
}

