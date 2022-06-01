# nat gw
resource "aws_eip" "nat1" {
  vpc   = true
}

resource "aws_eip" "nat2" {
  vpc   = true
}

resource "aws_nat_gateway" "nat-gw-1" {
  allocation_id = aws_eip.nat1.id
  subnet_id     = aws_subnet.pri-sub1.id
  depends_on    = [aws_internet_gateway.main-gateway]
  tags = {
      Name = "nat gateway 1"
  }
}

resource "aws_nat_gateway" "nat-gw-2" {
  allocation_id = aws_eip.nat2.id
  subnet_id     = aws_subnet.pri-sub2.id
  depends_on    = [aws_internet_gateway.main-gateway]
  tags = {
      Name = "nat gateway 2"
  }
}

# vpc setup for nat
resource "aws_route_table" "prisub-r1" {
  vpc_id = aws_vpc.app-vpc.id
  route {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.nat-gw-1.id
  }

  tags = {
    Name = "route table for private subnet 1"
  }
}

resource "aws_route_table" "prisub-r2" {
  vpc_id = aws_vpc.app-vpc.id
  route {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.nat-gw-1.id
  }

  tags = {
    Name = "route table for private subnet 2"
  }
}


# route association for private subnet1
resource "aws_route_table_association" "prisub-r1-a" {
  subnet_id      = aws_subnet.pri-sub1.id
  route_table_id = aws_route_table.prisub-r1.id
}

resource "aws_route_table_association" "prisub-r2-a" {
  subnet_id      = aws_subnet.pri-sub2.id
  route_table_id = aws_route_table.prisub-r2.id 
}