###########
### VPC ###
###########

resource "aws_vpc" "VPC" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = var.instance_tenancy

  tags = {
    Name = "${var.environment}-VPC"
  }
}

#########################
### PUBLIC-SUBNET ###
#########################

resource "aws_subnet" "PUBLIC-SUBNET-1A" {
  vpc_id = aws_vpc.VPC.id
  cidr_block = var.public_subnet[0] #"10.10.1.0/24"
  availability_zone = var.global_azs[0]

  tags = {
    Name = "${var.environment}-PUBLIC-SUBNET-1A"
  }
}
resource "aws_subnet" "PUBLIC-SUBNET-1B" {
  vpc_id = aws_vpc.VPC.id
  cidr_block = var.public_subnet[1] #"10.10.2.0/24"
  availability_zone = var.global_azs[1]

  tags = {
    Name = "${var.environment}-PUBLIC-SUBNET-1B"
  }
}
resource "aws_internet_gateway" "VPC_IGW" {
  vpc_id = aws_vpc.VPC.id
  tags = {
    Name = "${var.environment}_VPC_IGW"
  }
}
resource "aws_route_table" "PUBLIC-RT-TABLE" {
    vpc_id = aws_vpc.VPC.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.VPC_IGW.id
    }
    tags = {
        Name = "${var.environment}-PUBLIC-ROUTE-TABLE"
    }
}
resource "aws_route_table_association" "PUBLIC-RT-TABLE-1A" {
    subnet_id = aws_subnet.PUBLIC-SUBNET-1A.id
    route_table_id = aws_route_table.PUBLIC-RT-TABLE.id
}
resource "aws_route_table_association" "PUBLIC-RT-TABLE-1B" {
    subnet_id = aws_subnet.PUBLIC-SUBNET-1B.id
    route_table_id = aws_route_table.PUBLIC-RT-TABLE.id
}


#########################
### PRIVATE-SUBNET ##
#########################
resource "aws_subnet" "PRIVATE-SUBNET-1A" {
  vpc_id = aws_vpc.VPC.id
  cidr_block = var.private_subnet[0] #"10.10.3.0/24"
  availability_zone = var.global_azs[0]

  tags = {
    Name = "${var.environment}-PRIVATE-SUBNET-1A"
  }
}
resource "aws_subnet" "PRIVATE-SUBNET-1B" {
  vpc_id = aws_vpc.VPC.id
  cidr_block = var.private_subnet[1] #"10.10.4.0/24"
  availability_zone = var.global_azs[1]

  tags = {
    Name = "${var.environment}-PRIVATE-SUBNET-1B"
  }
}

resource "aws_eip" "NAT-EIP" {
  vpc = true
  tags = {
    Name = "${var.environment}-NAT-EIP"
  }
}

resource "aws_nat_gateway" "NAT-GW" {
  allocation_id = aws_eip.NAT-EIP.id
  subnet_id = aws_subnet.PRIVATE-SUBNET-1A.id
}

resource "aws_route_table" "PRIVATE-RT-TABLE" {
    vpc_id = aws_vpc.VPC.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.NAT-GW.id
    }
    tags = {
        Name = "${var.environment}-PRIVATE-ROUTE-TABLE"
    }
}

resource "aws_route_table_association" "PRIVATE-RT-TABLE-1A" {
    subnet_id = aws_subnet.PRIVATE-SUBNET-1A.id
    route_table_id = aws_route_table.PRIVATE-RT-TABLE.id
}
resource "aws_route_table_association" "PRIVATE-RT-TABLE-1B" {
    subnet_id = aws_subnet.PRIVATE-SUBNET-1B.id
    route_table_id = aws_route_table.PRIVATE-RT-TABLE.id
}


