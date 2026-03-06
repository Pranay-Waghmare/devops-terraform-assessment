resource "aws_lb" "devops_alb" {
  name               = "devops-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.alb_sg.id]

  subnets = [
    aws_subnet.public1.id,
    aws_subnet.public2.id
  ]
}

resource "aws_lb_target_group" "tg" {
  name     = "nginx-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.devops_vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_target_group_attachment" "tg_attach" {
  for_each = aws_instance.nginx

  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = each.value.id
  port             = 80
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.devops_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
