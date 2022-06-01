# set password rule
resource "random_password" "password" {
  length            =  8
  special           = true
  override_special  = "_%^"
}

# set password
resource "aws_ssm_parameter" "ssm_password" {
  name        = "dbpassword"
  description = "database password"
  type        = "SecureString"
  value       = random_password.password.result

  tags = {
    Name = "App database secure password"
  }
}

resource "aws_ssm_parameter" "ssm_db_host" {
  name        = "dbhost"
  description = "database host"
  type        = "SecureString"
  value       = aws_db_instance.app-db-instance.address
  tags = {
    Name = "App database hostname"
  }
}