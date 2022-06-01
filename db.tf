resource "aws_db_subnet_group" "app-db-subnet" {
  name        = "app-db-subnet"
  description = "RDS DB subnet group"
  subnet_ids  = [aws_subnet.pri-sub1.id, aws_subnet.pri-sub2.id]
}

resource "aws_db_instance" "app-db-instance" {
  allocated_storage       = 100 
  engine                  = "postgres"
  engine_version          = "9.6.22"
  instance_class          = "db.t3.micro"
  identifier              = "postgre"
  name                    = "app"
  username                = "postgre"
  password                = aws_ssm_parameter.ssm_password.value
  db_subnet_group_name    = aws_db_subnet_group.app-db-subnet.name
  multi_az                = "true"
  vpc_security_group_ids  = [aws_security_group.db-securitygroup.id]
  storage_type            = "gp2"
  backup_retention_period = 30
  skip_final_snapshot     = "true"

  tags =   {
      Name = "DB instance for app"
  }
}