###########
### VPC ###
###########

resource "aws_vpc" "VPC" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = var.instance_tenancy

  tags = {
    Name = "${var.environment}-VPC"
  }
}

#########################
### PUBLIC-SUBNET ###
#########################

resource "aws_subnet" "PUBLIC-SUBNET-1A" {
  vpc_id = aws_vpc.VPC.id
  cidr_block = var.public_subnet[0] #"10.10.1.0/24"
  availability_zone = var.global_azs[0]

  tags = {
    Name = "${var.environment}-PUBLIC-SUBNET-1A"
  }
}
resource "aws_subnet" "PUBLIC-SUBNET-1B" {
  vpc_id = aws_vpc.VPC.id
  cidr_block = var.public_subnet[1] #"10.10.2.0/24"
  availability_zone = var.global_azs[1]

  tags = {
    Name = "${var.environment}-PUBLIC-SUBNET-1B"
  }
}
resource "aws_internet_gateway" "VPC_IGW" {
  vpc_id = aws_vpc.VPC.id
  tags = {
    Name = "${var.environment}_VPC_IGW"
  }
}
resource "aws_route_table" "PUBLIC-RT-TABLE" {
    vpc_id = aws_vpc.VPC.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.VPC_IGW.id
    }
    tags = {
        Name = "${var.environment}-PUBLIC-ROUTE-TABLE"
    }
}
resource "aws_route_table_association" "PUBLIC-RT-TABLE-1A" {
    subnet_id = aws_subnet.PUBLIC-SUBNET-1A.id
    route_table_id = aws_route_table.PUBLIC-RT-TABLE.id
}
resource "aws_route_table_association" "PUBLIC-RT-TABLE-1B" {
    subnet_id = aws_subnet.PUBLIC-SUBNET-1B.id
    route_table_id = aws_route_table.PUBLIC-RT-TABLE.id
}


#########################
### PRIVATE-SUBNET ##
#########################
resource "aws_subnet" "PRIVATE-SUBNET-1A" {
  vpc_id = aws_vpc.VPC.id
  cidr_block = var.private_subnet[0] #"10.10.3.0/24"
  availability_zone = var.global_azs[0]

  tags = {
    Name = "${var.environment}-PRIVATE-SUBNET-1A"
  }
}
resource "aws_subnet" "PRIVATE-SUBNET-1B" {
  vpc_id = aws_vpc.VPC.id
  cidr_block = var.private_subnet[1] #"10.10.4.0/24"
  availability_zone = var.global_azs[1]

  tags = {
    Name = "${var.environment}-PRIVATE-SUBNET-1B"
  }
}

resource "aws_eip" "NAT-EIP" {
  vpc = true
  tags = {
    Name = "${var.environment}-NAT-EIP"
  }
}

resource "aws_nat_gateway" "NAT-GW" {
  allocation_id = aws_eip.NAT-EIP.id
  subnet_id = aws_subnet.PRIVATE-SUBNET-1A.id
}

resource "aws_route_table" "PRIVATE-RT-TABLE" {
    vpc_id = aws_vpc.VPC.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.NAT-GW.id
    }
    tags = {
        Name = "${var.environment}-PRIVATE-ROUTE-TABLE"
    }
}

resource "aws_route_table_association" "PRIVATE-RT-TABLE-1A" {
    subnet_id = aws_subnet.PRIVATE-SUBNET-1A.id
    route_table_id = aws_route_table.PRIVATE-RT-TABLE.id
}
resource "aws_route_table_association" "PRIVATE-RT-TABLE-1B" {
    subnet_id = aws_subnet.PRIVATE-SUBNET-1B.id
    route_table_id = aws_route_table.PRIVATE-RT-TABLE.id
}


resource "aws_security_group" "BASTION-HOST-SG" {
  name = "${var.environment}-BASTION-HOST-SG"
  description = "Allow SSH inbound connections"
  vpc_id = aws_vpc.VPC.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.environment}-BASTION-HOST-SG"
  }
}

resource "aws_instance" "BASTION-HOST" {
  ami = var.instace_image_id # ubuntu image
  instance_type = var.instance_type_def
  key_name = var.instace_key_name
  availability_zone = var.global_azs[1]
  vpc_security_group_ids = [ aws_security_group.BASTION-HOST-SG.id ]
  subnet_id = aws_subnet.PUBLIC-SUBNET-1A.id
  associate_public_ip_address = true

  tags = {
    Name = "${var.environment}-BASTION-HOST"
  }
}

#######################
## Autoscaling Group ##
#########


resource "aws_security_group" "ALB-SG" {
  name        = "ALB-${var.environment}-SG"
  description = "Allow HTTP traffic to instances through Elastic Load Balancer"
  vpc_id = aws_vpc.VPC.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow HTTP through ${var.environment} ALB Security Group"
  }
}

resource "aws_launch_configuration" "ALB-LAUNCH-CONFIG" {
  name_prefix = "terraform-"

  # image_id = "ami-052efd3df9dad4825" 
  # instance_type = "t1.micro"
  # key_name = "terraform-test"

  ami = var.instace_image_id # ubuntu image 
  instance_type = var.instance_type_def
  key_name = var.instace_key_name
  
  security_groups = [ aws_security_group.ALB-SG.id ]
  associate_public_ip_address = true
  user_data = <<-EOF
    #!/bin/bash
    apt update -y
    apt install nginx -y
    service nginx start
    EOF 
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ALB-ASG-GROUP" {
  name = "${aws_launch_configuration.ALB-LAUNCH-CONFIG.name}-asg"

  min_size             = 1
  desired_capacity     = 2
  max_size             = 4
  
  # health_check_type    = "ELB"
  # load_balancers = [
  #   aws_lb.ALB-QA.id
  # ]

  launch_configuration = aws_launch_configuration.ALB-LAUNCH-CONFIG.name

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity = "1Minute"

  vpc_zone_identifier  = [
    aws_subnet.PUBLIC-SUBNET-1A.id,
    aws_subnet.PUBLIC-SUBNET-1B.id
  ]

  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "terraform"
    propagate_at_launch = true
  }

}

resource "aws_lb" "Application_LB" {
  name               = "${var.environment}_Application_LB"
  internal           = false
  load_balancer_type = "application"
  
  security_groups = [
    aws_security_group.ALB-SG.id
  ]
  subnets = [
    aws_subnet.PUBLIC-SUBNET-1A.id,
    aws_subnet.PUBLIC-SUBNET-1B.id
  ]

}
resource "aws_lb_listener" "ALB-LISTENER" {
  load_balancer_arn = aws_lb.Application_LB.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ALB-TARGET.arn
  }
}

resource "aws_lb_target_group" "ALB-TARGET" {

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    path = "/"
    protocol = "HTTP"
  }
  
  name     = "learn-asg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.VPC.id

  
}

resource "aws_autoscaling_attachment" "ALB-ATTACHMENT" {
  autoscaling_group_name = aws_autoscaling_group.ALB-ASG-GROUP.id
  lb_target_group_arn   = aws_lb_target_group.ALB-TARGET.arn
}

resource "aws_autoscaling_policy" "web_policy_up" {
  name = "web_policy_up"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.ALB-ASG-GROUP.name
}

resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_up" {
  alarm_name = "web_cpu_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "60"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ALB-ASG-GROUP.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = [ aws_autoscaling_policy.web_policy_up.arn ]
}

resource "aws_autoscaling_policy" "web_policy_down" {
  name = "web_policy_down"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.ALB-ASG-GROUP.name
}

resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_down" {
  alarm_name = "web_cpu_alarm_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "10"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ALB-ASG-GROUP.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = [ aws_autoscaling_policy.web_policy_down.arn ]
}