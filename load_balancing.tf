resource "aws_lb_target_group" "lamptg" {
  name        = "tf-example-lb-tg"
  port        = 80
  target_type = "instance"
  protocol    = "HTTP"
  vpc_id      = aws_vpc.tutorial_vpc.id
}

resource "aws_lb_target_group_attachment" "attachmentgrp1" {
  target_group_arn = aws_lb_target_group.lamptg.arn
  target_id        = aws_instance.tutorial_web[0].id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attachmentgrp2" {
  target_group_arn = aws_lb_target_group.lamptg.arn
  target_id        = aws_instance.tutorial_web[1].id
  port             = 80
}

resource "aws_lb" "tutorial_alb" {
  internal                         = false
  load_balancer_type               = "application"
  subnets                          = [for subnet in aws_subnet.tutorial_public_subnet : subnet.id]
  security_groups                  = [aws_security_group.tutorial_web_sg.id]
  enable_cross_zone_load_balancing = true

  tags = {
    Environment = "production"
    Name        = "tutorial_alb"
  }
}

resource "aws_lb_listener" "lb_listener_http" {
  load_balancer_arn = aws_lb.tutorial_alb.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.lamptg.id
    type = "forward"
  }
}