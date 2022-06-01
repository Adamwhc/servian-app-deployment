resource "aws_lb" "app-lb" {
  name               = "app-alb"
  subnets            = [aws_subnet.pub-sub1.id, aws_subnet.pub-sub2.id]
  security_groups    = [aws_security_group.alb-securitygroup.id]
  load_balancer_type = "application"
  internal           = false

  tags = {
    "Name" = "app alb"
  }
}

resource "aws_lb_target_group" "app-lb-tg" {
  name        = "app-lb-tg"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.app-vpc.id
  target_type = "instance"
  
  health_check {
   healthy_threshold     = 2
   unhealthy_threshold   = 2
   timeout               = 3
   interval              = 30
   path                  = "/healthcheck/"
   port                  = 3000
  }
}

resource "aws_lb_listener" "app-lb-listener" {
  load_balancer_arn = aws_lb.app-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-lb-tg.arn
  }
}