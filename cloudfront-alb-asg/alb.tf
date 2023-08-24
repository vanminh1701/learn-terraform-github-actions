resource "aws_lb" "demo-lb" {
  name               = "${local.name}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = module.vpc.public_subnets
  # subnets            = [module.vpc.public_subnets[1], module.vpc.public_subnets[2]]
}

resource "aws_lb_target_group" "demo-web-target" {
  name     = "${local.name}-web-target"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
  stickiness {
    enabled = true
    type = "lb_cookie"
    cookie_duration = 60
  }
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

resource "aws_security_group" "alb-sg" {
  name = "${local.name}-alb-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = module.vpc.vpc_id
}
