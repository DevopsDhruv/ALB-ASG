# Creating VPC
resource "aws_vpc" "VPC-one" {
  # 10.0.0.0/16
  cidr_block = var.VPC_cidr

  tags = {
    Name = var.VPC_name
  }
}

# Creating public subnet
resource "aws_subnet" "Public-sub" {
  # 10.0.1.0/24, 10.0.2.0/24
  count             = length(var.Public_cidr)
  vpc_id            = aws_vpc.VPC-one.id
  cidr_block        = element(var.Public_cidr, count.index)
  availability_zone = element(var.public_sub_az, count.index)

  tags = {
    Name = "public_sub-${count.index + 1}"
  }
}

# Creating Internet gateway for VPC

resource "aws_internet_gateway" "VPC-internet" {
  vpc_id = aws_vpc.VPC-one.id

  tags = {
    Name = var.VPC_internet-name
  }
}

# Creating route table for public sub
resource "aws_route_table" "Public_route" {
  vpc_id = aws_vpc.VPC-one.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.VPC-internet.id
  }

  tags = {
    Name = var.public_route-name
  }
}

# Attach route table to public subnet
resource "aws_route_table_association" "public_route_accociation" {
  count = length(var.Public_cidr)

  # Public-sub[0], Public-sub[1]
  subnet_id      = aws_subnet.Public-sub[count.index].id
  route_table_id = aws_route_table.Public_route.id
}