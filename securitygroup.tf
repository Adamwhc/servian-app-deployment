resource "aws_security_group" "alb-securitygroup" {
  vpc_id      = aws_vpc.app-vpc.id
  name        = "alb"
  description = "security group for load balancer"
  egress  {
    from_port   = 0 
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 

  tags = {
    Name = "alb"
  }
}

resource "aws_security_group" "app-securitygroup" {
  vpc_id      = aws_vpc.app-vpc.id
  name        = "instance security group"
  description = "security group for my instance"
  egress  {
    from_port   = 0  
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  } 

  ingress  {
    from_port   = 3000 
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.alb-securitygroup.id]
  } 

  tags = {
    "Name" = "instance asg"
  }
}

resource "aws_security_group" "db-securitygroup" {
  vpc_id = aws_vpc.app-vpc.id
  name = "db-securitygroup"
  description = "security group for database"
  egress  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  } 

  ingress  {
    from_port       = 5432  
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app-securitygroup.id]
  } 

  tags = {
    Name = "database securitygroup"
  }
}

