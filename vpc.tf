# main vpc created for app
resource "aws_vpc" "app-vpc" {
  cidr_block            = "10.0.0.0/16"
  enable_dns_support    = "true"
  enable_dns_hostnames  = "true"
  enable_classiclink    = "false"

  tags = {
    Name = "Servian App"
  }
}

# two public subnets in 2 AZs
resource "aws_subnet" "pub-sub1" {
  vpc_id                    = aws_vpc.app-vpc.id
  cidr_block                = "10.0.1.0/24"
  map_public_ip_on_launch   = "true"
  availability_zone         = "ap-southeast-2a"
  
  tags = {
    Name = "public subnet1"
  }
}

resource "aws_subnet" "pub-sub2" {
  vpc_id                    = aws_vpc.app-vpc.id
  cidr_block                = "10.0.2.0/24"
  map_public_ip_on_launch   = "true"
  availability_zone         = "ap-southeast-2b"
  
  tags = {
    Name = "public subnet2"
  }
}

# two private subnets in 2 AZs
resource "aws_subnet" "pri-sub1" {
  vpc_id                    = aws_vpc.app-vpc.id
  cidr_block                = "10.0.4.0/24"
  map_public_ip_on_launch   = "false"
  availability_zone         = "ap-southeast-2a"
  
  tags = {
    Name = "private subnet1"
  }
}

resource "aws_subnet" "pri-sub2" {
  vpc_id                    = aws_vpc.app-vpc.id
  cidr_block                = "10.0.5.0/24"
  map_public_ip_on_launch   = "false"
  availability_zone         = "ap-southeast-2b"
  
  tags = {
    Name = "private subnet2"
  }
}



# Internet Gateway
resource "aws_internet_gateway" "main-gateway" {
  vpc_id = aws_vpc.app-vpc.id

  tags = {
    Name  = "main internet gateway"
  }
}

# route tables
resource "aws_route_table" "main-public" {
  vpc_id = aws_vpc.app-vpc.id
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.main-gateway.id
  }

  tags = {
      Name = "main route table for public subnet"
  }
}

# route associations public
resource "aws_route_table_association" "subpub1-a" {
  subnet_id      = aws_subnet.pub-sub1.id 
  route_table_id = aws_route_table.main-public.id
}

resource "aws_route_table_association" "subpub2-a" {
  subnet_id      = aws_subnet.pub-sub2.id 
  route_table_id = aws_route_table.main-public.id
}