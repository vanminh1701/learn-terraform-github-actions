resource "aws_lb" "demo-lb" {
  name               = "demo-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = [module.vpc.public_subnets[1], module.vpc.public_subnets[2]]
}

resource "aws_lb_target_group" "demo-web-target" {
  name     = "demo-web-target"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}


resource "aws_lb_listener" "demo-alb-listener" {
  load_balancer_arn = aws_lb.demo-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.demo-web-target.arn
  }
}
