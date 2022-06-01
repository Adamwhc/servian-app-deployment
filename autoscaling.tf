# resource "aws_key_pair" "mykey" {
#   key_name   = "mykey"
#   public_key = file(var.PATH_TO_PUBLIC_KEY)
# }

resource "aws_launch_configuration" "app-lc" {
  name_prefix          = "app-lc"
  image_id             = var.AMIS
  instance_type        = "t2.micro"
  # key_name             = aws_key_pair.mykey.key_name
  iam_instance_profile = aws_iam_instance_profile.app-iam-ins.name
  security_groups      = [aws_security_group.app-securitygroup.id]
  user_data            = file("appscript.sh")
  lifecycle {
      create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "app-autoscaling" {
  name                      = "app-autoscaling"
  launch_configuration      = aws_launch_configuration.app-lc.name
  vpc_zone_identifier       = [aws_subnet.pub-sub1.id, aws_subnet.pub-sub2.id]
  depends_on                = [aws_launch_configuration.app-lc, aws_db_instance.app-db-instance]
  min_size                  = 2
  max_size                  = 3
  health_check_grace_period = 300
  health_check_type         = "EC2"
  force_delete = true
  
  tag {
      key                 = "Name"
      value               = "App"
      propagate_at_launch = true
  } 
}

# add target group to alb
resource "aws_autoscaling_attachment" "app-asg-attachment" {
  autoscaling_group_name = aws_autoscaling_group.app-autoscaling.id
  alb_target_group_arn = aws_lb_target_group.app-lb-tg.arn
}