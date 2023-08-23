resource "aws_launch_configuration" "demo-launch-config" {
  name_prefix   = "asg-instance-"
  image_id      = "ami-09e67e426f25ce0d7"
  instance_type = "t3.micro"

  user_data = <<-EOF
            #!/bin/bash
            echo "Hello, World" > index.html
            nohup busybox httpd -f -p 8080 &
            EOF

  security_groups = [aws_security_group.web-sg.id]

  # You cannot modify a launch configuration, 
  # so any changes to the definition force Terraform to create a new resource. 
  # The create_before_destroy argument in the lifecycle block instructs 
  # Terraform to create the new version before destroying the original to avoid any service interruptions.
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "demo-asg" {
  name                      = "demo-asg"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1
  force_delete              = true
  launch_configuration      = aws_launch_configuration.demo-launch-config.name
  vpc_zone_identifier       = module.vpc.public_subnets
}

resource "aws_autoscaling_attachment" "asg-attachment" {
  autoscaling_group_name = aws_autoscaling_group.demo-asg.id
  lb_target_group_arn    = aws_lb_target_group.demo-web-target.arn
}
