###########
### VPC ###
###########

resource "aws_vpc" "QA_VPC" {
  cidr_block       = "10.10.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "QA_VPC"
  }
}

resource "aws_vpc" "UAT_VPC" {
  cidr_block       = "10.20.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "UAT_VPC"
  }
}

resource "aws_vpc" "PROD_VPC" {
  cidr_block       = "10.30.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "PROD_VPC"
  }
}

#########################
### QA-PUBLIC-SUBNET ###
#########################

resource "aws_subnet" "QA-PUBLIC-SUBNET-1A" {
  vpc_id = aws_vpc.QA_VPC.id
  cidr_block = "10.10.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "QA-PUBLIC-SUBNET-1A"
  }
}
resource "aws_subnet" "QA-PUBLIC-SUBNET-1B" {
  vpc_id = aws_vpc.QA_VPC.id
  cidr_block = "10.10.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "QA-PUBLIC-SUBNET-1B"
  }
}
resource "aws_internet_gateway" "QA_VPC_IGW" {
  vpc_id = aws_vpc.QA_VPC.id
  tags = {
    Name = "QA_VPC_IGW"
  }
}
resource "aws_route_table" "QA-PUBLIC-RT-TABLE" {
    vpc_id = aws_vpc.QA_VPC.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.QA_VPC_IGW.id
    }
    tags = {
        Name = "QA-PUBLIC-ROUTE-TABLE"
    }
}
resource "aws_route_table_association" "QA-PUBLIC-RT-TABLE-1A" {
    subnet_id = aws_subnet.QA-PUBLIC-SUBNET-1A.id
    route_table_id = aws_route_table.QA-PUBLIC-RT-TABLE.id
}
resource "aws_route_table_association" "QA-PUBLIC-RT-TABLE-1B" {
    subnet_id = aws_subnet.QA-PUBLIC-SUBNET-1B.id
    route_table_id = aws_route_table.QA-PUBLIC-RT-TABLE.id
}


#########################
### QA-PRIVATE-SUBNET ##
#########################
resource "aws_subnet" "QA-PRIVATE-SUBNET-1A" {
  vpc_id = aws_vpc.QA_VPC.id
  cidr_block = "10.10.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "QA-PRIVATE-SUBNET-1A"
  }
}
resource "aws_subnet" "QA-PRIVATE-SUBNET-1B" {
  vpc_id = aws_vpc.QA_VPC.id
  cidr_block = "10.10.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "QA-PRIVATE-SUBNET-1B"
  }
}

resource "aws_eip" "QA-NAT-EIP" {
  vpc = true
  tags = {
    Name = "QA-NAT-EIP"
  }
}

resource "aws_nat_gateway" "QA-NAT-GW" {
  allocation_id = aws_eip.QA-NAT-EIP.id
  subnet_id = aws_subnet.QA-PRIVATE-SUBNET-1A.id
}

resource "aws_route_table" "QA-PRIVATE-RT-TABLE" {
    vpc_id = aws_vpc.QA_VPC.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.QA-NAT-GW.id
    }
    tags = {
        Name = "QA-PRIVATE-ROUTE-TABLE"
    }
}

resource "aws_route_table_association" "QA-PRIVATE-RT-TABLE-1A" {
    subnet_id = aws_subnet.QA-PRIVATE-SUBNET-1A.id
    route_table_id = aws_route_table.QA-PRIVATE-RT-TABLE.id
}
resource "aws_route_table_association" "QA-PRIVATE-RT-TABLE-1B" {
    subnet_id = aws_subnet.QA-PRIVATE-SUBNET-1B.id
    route_table_id = aws_route_table.QA-PRIVATE-RT-TABLE.id
}

#########################
### UAT-PUBLIC-SUBNET ###
#########################

resource "aws_subnet" "UAT-PUBLIC-SUBNET-1A" {
  vpc_id = aws_vpc.UAT_VPC.id
  cidr_block = "10.20.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "UAT-PUBLIC-SUBNET-1A"
  }
}
resource "aws_subnet" "UAT-PUBLIC-SUBNET-1B" {
  vpc_id = aws_vpc.UAT_VPC.id
  cidr_block = "10.20.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "UAT-PUBLIC-SUBNET-1B"
  }
}
resource "aws_internet_gateway" "UAT_VPC_IGW" {
  vpc_id = aws_vpc.UAT_VPC.id
  tags = {
    Name = "UAT_VPC_IGW"
  }
}
resource "aws_route_table" "UAT-PUBLIC-RT-TABLE" {
    vpc_id = aws_vpc.UAT_VPC.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.UAT_VPC_IGW.id
    }
    tags = {
        Name = "UAT-PUBLIC-ROUTE-TABLE"
    }
}
resource "aws_route_table_association" "UAT-PUBLIC-RT-TABLE-1A" {
    subnet_id = aws_subnet.UAT-PUBLIC-SUBNET-1A.id
    route_table_id = aws_route_table.UAT-PUBLIC-RT-TABLE.id
}
resource "aws_route_table_association" "UAT-PUBLIC-RT-TABLE-1B" {
    subnet_id = aws_subnet.UAT-PUBLIC-SUBNET-1B.id
    route_table_id = aws_route_table.UAT-PUBLIC-RT-TABLE.id
}

#########################
### UAT-PRIVATE-SUBNET ##
#########################
resource "aws_subnet" "UAT-PRIVATE-SUBNET-1A" {
  vpc_id = aws_vpc.UAT_VPC.id
  cidr_block = "10.20.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "UAT-PRIVATE-SUBNET-1A"
  }
}
resource "aws_subnet" "UAT-PRIVATE-SUBNET-1B" {
  vpc_id = aws_vpc.UAT_VPC.id
  cidr_block = "10.20.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "UAT-PRIVATE-SUBNET-1B"
  }
}

resource "aws_eip" "UAT-NAT-EIP" {
  vpc = true
  tags = {
    Name = "UAT-NAT-EIP"
  }
}

resource "aws_nat_gateway" "UAT-NAT-GW" {
  allocation_id = aws_eip.UAT-NAT-EIP.id
  subnet_id = aws_subnet.UAT-PRIVATE-SUBNET-1A.id
}

resource "aws_route_table" "UAT-PRIVATE-RT-TABLE" {
    vpc_id = aws_vpc.UAT_VPC.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.UAT-NAT-GW.id
    }
    tags = {
        Name = "UAT-PRIVATE-ROUTE-TABLE"
    }
}

resource "aws_route_table_association" "UAT-PRIVATE-RT-TABLE-1A" {
    subnet_id = aws_subnet.UAT-PRIVATE-SUBNET-1A.id
    route_table_id = aws_route_table.UAT-PRIVATE-RT-TABLE.id
}
resource "aws_route_table_association" "UAT-PRIVATE-RT-TABLE-1B" {
    subnet_id = aws_subnet.UAT-PRIVATE-SUBNET-1B.id
    route_table_id = aws_route_table.UAT-PRIVATE-RT-TABLE.id
}

#########################
### PROD-PUBLIC-SUBNET ###
#########################

resource "aws_subnet" "PROD-PUBLIC-SUBNET-1A" {
  vpc_id = aws_vpc.PROD_VPC.id
  cidr_block = "10.30.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "PROD-PUBLIC-SUBNET-1A"
  }
}
resource "aws_subnet" "PROD-PUBLIC-SUBNET-1B" {
  vpc_id = aws_vpc.PROD_VPC.id
  cidr_block = "10.30.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "PROD-PUBLIC-SUBNET-1B"
  }
}
resource "aws_internet_gateway" "PROD_VPC_IGW" {
  vpc_id = aws_vpc.PROD_VPC.id
  tags = {
    Name = "PROD_VPC_IGW"
  }
}
resource "aws_route_table" "PROD-PUBLIC-RT-TABLE" {
    vpc_id = aws_vpc.PROD_VPC.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.PROD_VPC_IGW.id
    }
    tags = {
        Name = "PROD-PUBLIC-ROUTE-TABLE"
    }
}
resource "aws_route_table_association" "PROD-PUBLIC-RT-TABLE-1A" {
    subnet_id = aws_subnet.PROD-PUBLIC-SUBNET-1A.id
    route_table_id = aws_route_table.PROD-PUBLIC-RT-TABLE.id
}
resource "aws_route_table_association" "PROD-PUBLIC-RT-TABLE-1B" {
    subnet_id = aws_subnet.PROD-PUBLIC-SUBNET-1B.id
    route_table_id = aws_route_table.PROD-PUBLIC-RT-TABLE.id
}

#########################
### PROD-PRIVATE-SUBNET ##
#########################
resource "aws_subnet" "PROD-PRIVATE-SUBNET-1A" {
  vpc_id = aws_vpc.PROD_VPC.id
  cidr_block = "10.30.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "PROD-PRIVATE-SUBNET-1A"
  }
}
resource "aws_subnet" "PROD-PRIVATE-SUBNET-1B" {
  vpc_id = aws_vpc.PROD_VPC.id
  cidr_block = "10.30.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "PROD-PRIVATE-SUBNET-1B"
  }
}

resource "aws_eip" "PROD-NAT-EIP" {
  vpc = true
  tags = {
    Name = "PROD-NAT-EIP"
  }
}

resource "aws_nat_gateway" "PROD-NAT-GW" {
  allocation_id = aws_eip.PROD-NAT-EIP.id
  subnet_id = aws_subnet.PROD-PRIVATE-SUBNET-1A.id
}

resource "aws_route_table" "PROD-PRIVATE-RT-TABLE" {
    vpc_id = aws_vpc.PROD_VPC.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.PROD-NAT-GW.id
    }
    tags = {
        Name = "PROD-PRIVATE-ROUTE-TABLE"
    }
}

resource "aws_route_table_association" "PROD-PRIVATE-RT-TABLE-1A" {
    subnet_id = aws_subnet.PROD-PRIVATE-SUBNET-1A.id
    route_table_id = aws_route_table.PROD-PRIVATE-RT-TABLE.id
}
resource "aws_route_table_association" "PROD-PRIVATE-RT-TABLE-1B" {
    subnet_id = aws_subnet.PROD-PRIVATE-SUBNET-1B.id
    route_table_id = aws_route_table.PROD-PRIVATE-RT-TABLE.id
}

###########################################################################

resource "aws_security_group" "MYSERVER-QA-SG" {  ## Replace MYSERVER-QA-SG with your server name
  name = "MYSERVER-QA-SG"
  description = "Allow SSH inbound connections"
  vpc_id = aws_vpc.QA_VPC.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "MYSERVER-QA-SG"
  }
}

#########
## ASG ##
#########

resource "aws_launch_configuration" "MYSERVER-QA" {
  name_prefix = "terraform-"

  image_id = "ami-052efd3df9dad4825" # Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = "t1.micro"
  key_name = "terraform-test"
  
  security_groups = [ aws_security_group.MYSERVER-QA-SG.id ]
  associate_public_ip_address = true
  user_data = <<EOF
  apt install nginx
chkconfig nginx on
service nginx start
  EOF 

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_security_group" "ALB-QA-SG" {
  name        = "ALB-QA-SG"
  description = "Allow HTTP traffic to instances through Elastic Load Balancer"
  vpc_id = aws_vpc.QA_VPC.id

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
    Name = "Allow HTTP through QA ALB Security Group"
  }
}


resource "aws_autoscaling_group" "test-asg-group" {
  name = "${aws_launch_configuration.MYSERVER-QA.name}-asg"

  min_size             = 1
  desired_capacity     = 2
  max_size             = 4
  
  # health_check_type    = "ELB"
  # load_balancers = [
  #   aws_lb.ALB-QA.id
  # ]

  launch_configuration = aws_launch_configuration.MYSERVER-QA.name

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity = "1Minute"

  vpc_zone_identifier  = [
    aws_subnet.QA-PUBLIC-SUBNET-1A.id,
    aws_subnet.QA-PUBLIC-SUBNET-1B.id
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

resource "aws_lb" "ALB-QA" {
  name               = "ALB-QA"
  internal           = false
  load_balancer_type = "application"
  
  security_groups = [
    aws_security_group.ALB-QA-SG.id
  ]
  subnets = [
    aws_subnet.QA-PUBLIC-SUBNET-1A.id,
    aws_subnet.QA-PUBLIC-SUBNET-1B.id
  ]
  # cross_zone_load_balancing   = true

  # health_check {
  #   healthy_threshold = 2
  #   unhealthy_threshold = 2
  #   timeout = 3
  #   interval = 30
  #   target = "HTTP:80/"
  # }

  # listener {
  #   lb_port = 80
  #   lb_protocol = "http"
  #   instance_port = "80"
  #   instance_protocol = "http"
  # }

}
resource "aws_lb_listener" "ALB-QA-LISTENER" {
  load_balancer_arn = aws_lb.ALB-QA.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ALB-QA-TARGET.arn
  }
}

resource "aws_lb_target_group" "ALB-QA-TARGET" {

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    path = "/"
    protocol = "HTTP"
  }
  
  name     = "learn-asg-QA"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.QA_VPC.id

  
}

resource "aws_autoscaling_attachment" "ALB-QA-ATTACHMENT" {
  autoscaling_group_name = aws_autoscaling_group.test-asg-group.id
  lb_target_group_arn   = aws_lb_target_group.ALB-QA-TARGET.arn
}

resource "aws_autoscaling_policy" "web_policy_up" {
  name = "web_policy_up"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.test-asg-group.name
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
    AutoScalingGroupName = aws_autoscaling_group.test-asg-group.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = [ aws_autoscaling_policy.web_policy_up.arn ]
}

resource "aws_autoscaling_policy" "web_policy_down" {
  name = "web_policy_down"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.test-asg-group.name
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
    AutoScalingGroupName = aws_autoscaling_group.test-asg-group.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = [ aws_autoscaling_policy.web_policy_down.arn ]
}

#########################
### QA-PUBLIC-SUBNET ###
#########################

resource "aws_subnet" "QA-PUBLIC-SUBNET-1A" {
  vpc_id = aws_vpc.QA_VPC.id
  cidr_block = "10.10.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "QA-PUBLIC-SUBNET-1A"
  }
}
resource "aws_subnet" "QA-PUBLIC-SUBNET-1B" {
  vpc_id = aws_vpc.QA_VPC.id
  cidr_block = "10.10.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "QA-PUBLIC-SUBNET-1B"
  }
}
resource "aws_internet_gateway" "QA_VPC_IGW" {
  vpc_id = aws_vpc.QA_VPC.id
  tags = {
    Name = "QA_VPC_IGW"
  }
}
resource "aws_route_table" "QA-PUBLIC-RT-TABLE" {
    vpc_id = aws_vpc.QA_VPC.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.QA_VPC_IGW.id
    }
    tags = {
        Name = "QA-PUBLIC-ROUTE-TABLE"
    }
}
resource "aws_route_table_association" "QA-PUBLIC-RT-TABLE-1A" {
    subnet_id = aws_subnet.QA-PUBLIC-SUBNET-1A.id
    route_table_id = aws_route_table.QA-PUBLIC-RT-TABLE.id
}
resource "aws_route_table_association" "QA-PUBLIC-RT-TABLE-1B" {
    subnet_id = aws_subnet.QA-PUBLIC-SUBNET-1B.id
    route_table_id = aws_route_table.QA-PUBLIC-RT-TABLE.id
}