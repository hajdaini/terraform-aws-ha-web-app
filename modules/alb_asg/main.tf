# Security group for ALB
resource "aws_security_group" "sg-alb" {
  vpc_id        = var.vpc_id
  name          = "${var.prefix_name}-sg-alb"
  description   = "security group for the load balancer"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.webserver_port
    to_port     = var.webserver_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.prefix_name}-sg-alb"
  }
}

# Security group for ASG instances
resource "aws_security_group" "sg-instances" {
  vpc_id            = var.vpc_id
  name              = "${var.prefix_name}-sg-webserver"
  description       = "security group for the ASG instances"
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = var.webserver_port
    to_port         = var.webserver_port
    protocol        = "tcp"
    security_groups = [aws_security_group.sg-alb.id]
  }

  tags = {
    Name = "${var.prefix_name}-sg-webserver"
  }
}

# Public key to connect to ec2 instances
resource "aws_key_pair" "mykeypair" {
  key_name   = "${var.prefix_name}-key"
  public_key = file(var.path_to_public_key)
}

# ASG launch configuration
resource "aws_launch_configuration" "my-launchconfig" {
  name_prefix          = "${var.prefix_name}-launchconfig"
  image_id             = var.ami
  instance_type        = var.instance_type
  key_name             = aws_key_pair.mykeypair.key_name
  security_groups      = [aws_security_group.sg-instances.id]
  user_data            = var.user_data   
  iam_instance_profile = var.role_profile_name

  lifecycle {
    create_before_destroy = true
  }
}

# ASG
resource "aws_autoscaling_group" "my-autoscaling" {
  name                      = "${var.prefix_name}-autoscaling"
  vpc_zone_identifier       = var.private_subnet_ids
  launch_configuration      = aws_launch_configuration.my-launchconfig.name
  min_size                  = var.min_instance
  desired_capacity          = var.desired_instance 
  max_size                  = var.max_instance
  health_check_grace_period = 300
  health_check_type         = "ELB"
  target_group_arns         = [ aws_lb_target_group.my-alb-target-group.arn ]
  force_delete              = true

  tag {
    key                     = "Name"
    value                   = "${var.prefix_name}"
    propagate_at_launch     = true
  }

}

# ALB
resource "aws_lb" "my-alb" {
  name               = "${var.prefix_name}-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  security_groups    = [aws_security_group.sg-alb.id]

  tags = {
    Name = "my-alb-tf"
  }
}

# ALB Targets
resource "aws_lb_target_group" "my-alb-target-group" {
  name     = "${var.prefix_name}-tg"
  port     = var.webserver_port
  protocol = var.webserver_protocol
  vpc_id   = var.vpc_id
}

# ALB listener
resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn  = "${aws_lb.my-alb.arn}"
  port               = var.webserver_port
  protocol           = var.webserver_protocol

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.my-alb-target-group.arn}"
  }
}