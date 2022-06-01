# scale up alarm
resource "aws_autoscaling_policy" "app-cpu-policy" {
  name                   = "app-cpu-policy"
  autoscaling_group_name = aws_autoscaling_group.app-autoscaling.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "app-cpu-alarm" {
  alarm_name            = "app-cpu-alarm"
  alarm_description     = "app-cpu-alarm"
  comparison_operator   = "GreaterThanOrEqualToThreshold"
  evaluation_periods    = "2"
  metric_name           = "CPUUtilization"
  namespace             = "AWS/EC2"
  period                = "120"
  statistic             = "Average"
  threshold             = "30"

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.app-autoscaling.name
  }

  actions_enabled = true
  alarm_actions = [aws_autoscaling_policy.app-cpu-policy.arn]
}

# scale down alarm
resource "aws_autoscaling_policy" "app-cpu-policy-scaledown" {
  name                   = "app-cpu-policy-scaledown"
  autoscaling_group_name = aws_autoscaling_group.app-autoscaling.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "app-cpu-alarm-scaledown" {
  alarm_name            = "app-cpu-alarm-scaledown"
  alarm_description     = "app-cpu-alarm-scaledown"
  comparison_operator   = "GreaterThanOrEqualToThreshold"
  evaluation_periods    = "2"
  metric_name           = "CPUUtilization"
  namespace             = "AWS/EC2"
  period                = "120"
  statistic             = "Average"
  threshold             = "5"

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.app-autoscaling.name
  }

  actions_enabled = true
  alarm_actions = [aws_autoscaling_policy.app-cpu-policy-scaledown.arn]
}