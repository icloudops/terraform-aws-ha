# Create a VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# Declare the data source for available AZs in the specified region##
data "aws_availability_zones" "available" {
  state = "available"
}

#create publica and private subnets
resource "aws_subnet" "public-subnet-1a" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_cidr[0]
  availability_zone = data.aws_availability_zones.available.names[0] 
  tags = {
    Name = "${var.project_name}-public-subnet-1a"
  }
}
resource "aws_subnet" "public-subnet-1b" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_cidr[1]
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "${var.project_name}-public-subnet-1b"
  }
}
resource "aws_subnet" "private-subnet-1a" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_cidr[0]
  availability_zone = data.aws_availability_zones.available.names[0] 
  tags = {
    Name = "${var.project_name}-private-1a"
  }
}
resource "aws_subnet" "private-subnet-1b" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_cidr[1]
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "${var.project_name}-private-1b"
  }
}


#create igw and nat gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

###Creating AWS NAT GW in the public subnet 0 in AZ1###
###Creating 2 EIPs for the NAT GW###
resource "aws_eip" "natgw_eip1" {
  vpc = true

  tags = {
    Name = "${var.project_name}-natgw_eip1"
  }
}
resource "aws_eip" "natgw_eip2" {
  vpc = true
 
  tags = {
    Name = "${var.project_name}-natgw_eip2"
  }
}

resource "aws_nat_gateway" "nat1" {
  allocation_id = aws_eip.natgw_eip1.id
  subnet_id     = aws_subnet.public-subnet-1a.id
  depends_on = [aws_internet_gateway.igw]
 
  tags = {
    Name = "${var.project_name}-natgw1"
  }
}

resource "aws_nat_gateway" "nat2" {
  allocation_id = aws_eip.natgw_eip2.id 
  subnet_id     = aws_subnet.public-subnet-1b.id
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "${var.project_name}-natgw2"
  }
}
###Creating Route Tables for the Public and private subnets###
resource "aws_route_table" "private_route_table_a" {
  vpc_id = aws_vpc.vpc.id
  route {
  cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat1.id
  }
  
  tags = {
    Name = "${var.project_name}-private-rt-a"
  }
}

resource "aws_route_table" "private_route_table_b" {
  vpc_id = aws_vpc.vpc.id
  route {
  cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat2.id
  }

  tags = {
    Name = "${var.project_name}-private-rt-b"
  }
}

resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.vpc.id
    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
   
  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

### Associating the 2 public subnets and 2 private subnets with the RT####

resource "aws_route_table_association" "public_subnet_assossiation_a" {
  subnet_id = aws_subnet.public-subnet-1a.id

## aws_subnet.public_subnet.*.id[0]
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_assossiation_b" {
  subnet_id = aws_subnet.public-subnet-1b.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_subnet_assossiation_a" {
  subnet_id = aws_subnet.private-subnet-1a.id
  route_table_id = aws_route_table.private_route_table_a.id
}

resource "aws_route_table_association" "private_subnet_assossiation_b" {
  subnet_id = aws_subnet.private-subnet-1b.id
  route_table_id = aws_route_table.private_route_table_b.id
}