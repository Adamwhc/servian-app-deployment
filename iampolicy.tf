resource "aws_iam_role" "app-user" {
  name               = "app-user"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Principal": {
                "Service": [
                    "ec2.amazonaws.com"
                ]
            }
        }
    ]
}
EOF

  tags = {
    Name = "IAM role for app user"
  }
}

resource "aws_iam_policy" "app-user-policy" {
    name        = "user-policy"
    description = "policy for app user"
    
    policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "cloudwatch:*",
                "s3:*",
                "logs:*",
                "ssm:*",
                "ec2:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
    tags = {
      Name = "policy for app"
    }
}

# attach role to policy
resource "aws_iam_role_policy_attachment" "app-policy-attach" {
  role       = aws_iam_role.app-user.name
  policy_arn = aws_iam_policy.app-user-policy.arn
}

# attach role to an instance profile
resource "aws_iam_instance_profile" "app-iam-ins" {
  name = "app_iam_instance_profile"
  role = aws_iam_role.app-user.name
}