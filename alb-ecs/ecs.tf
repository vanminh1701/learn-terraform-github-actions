module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "5.2.2"

  cluster_name = "ecs-integrated"

  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = "/aws/ecs/aws-ec2"
      }
    }
  }

  services = {
    ecsdemo-frontend = {
      desired_count      = 1
      enable_autoscaling = false
      assign_public_ip   = true

      # Container definition(s)
      container_definitions = {
        nginx = {
          cpu       = 512
          memory    = 1024
          essential = true
          image     = "nginxdemos/hello"

          readonly_root_filesystem  = false
          enable_cloudwatch_logging = false
          memory_reservation        = 100

          port_mappings = [
            {
              name          = "nginx-80-800000"
              containerPort = 80
              protocol      = "tcp"
            }
          ]
          tags = local.tags

        }
      }

      subnet_ids = local.subnet_ids

      load_balancer = {
        service = {
          target_group_arn = element(module.alb.target_group_arns, 0)
          container_name   = "nginx"
          container_port   = 80
        }
      }

      security_group_rules = {
        alb_ingress_3000 = {
          type                     = "ingress"
          from_port                = 80
          to_port                  = 80
          protocol                 = "tcp"
          description              = "Service port"
          source_security_group_id = module.alb_sg.security_group_id
        }

        egress_all = {
          type        = "egress"
          from_port   = 80
          to_port     = 80
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }
    }

  }
}

#############

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = "nginxdemos-alb"

  load_balancer_type = "application"

  vpc_id          = data.aws_vpc.default.id
  subnets         = local.subnet_ids
  security_groups = [module.alb_sg.security_group_id]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    },
  ]

  target_groups = [
    {
      name             = "nginxdemos"
      backend_protocol = "HTTP"
      backend_port     = "80"
      target_type      = "ip"
    },
  ]

  tags = local.tags
}

module "alb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "${local.name}-service"
  description = "Service security group"

  ingress_rules       = ["http-80-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  egress_rules       = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]

  tags = local.tags
}