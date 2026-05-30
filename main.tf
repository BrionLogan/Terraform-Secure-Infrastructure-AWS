resource "aws_vpc" "secure_vpc" {

  cidr_block = "10.0.0.0/16"

  enable_dns_support = true

  enable_dns_hostnames = true

  tags = {
    Name = "secure-vpc"
  }
}

resource "aws_subnet" "public_1" {

  vpc_id = aws_vpc.secure_vpc.id

  cidr_block = "10.0.1.0/24"

  availability_zone = "us-east-1a"

  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_2" {

  vpc_id = aws_vpc.secure_vpc.id

  cidr_block = "10.0.2.0/24"

  availability_zone = "us-east-1b"

  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.secure_vpc.id
}

resource "aws_route_table" "public_rt" {

  vpc_id = aws_vpc.secure_vpc.id

  route {
    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.igw.id
  }
}
resource "aws_route_table_association" "public_1_assoc" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_2_assoc" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP traffic to ALB"
  vpc_id      = aws_vpc.secure_vpc.id

  ingress {
    description = "Allow HTTP from my IP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["76.123.124.140/32"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  description = "Allow HTTP from ALB and SSH from my IP"
  vpc_id      = aws_vpc.secure_vpc.id

  ingress {
    description     = "Allow HTTP from ALB only"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }
  ingress {
    description = "Allow SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["76.123.124.140/32"]
  }
  ingress {
    description = "Allow SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["76.123.124.140/32"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-sg"
  }
}

resource "aws_instance" "web_server" {
  ami                         = "ami-0c02fb55956c7d316"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_1.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true
  key_name                    = "terraform-secure-vpc-kp"

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl enable httpd
              systemctl start httpd
              echo "Hello from Terraform Secure AWS Lab" > /var/www/html/index.html
              EOF

  tags = {
    Name = "secure-web-server"
  }
}

resource "aws_ebs_volume" "encrypted_ebs" {
  availability_zone = "us-east-1a"
  size              = 8
  encrypted         = true

  tags = {
    Name = "encrypted-ebs-volume"
  }
}

resource "aws_volume_attachment" "ebs_attach" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.encrypted_ebs.id
  instance_id = aws_instance.web_server.id
}

resource "aws_lb_target_group" "web_tg" {
  name     = "secure-web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.secure_vpc.id

  health_check {
    path = "/"
  }
}

resource "aws_lb_target_group_attachment" "web_attach" {
  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id        = aws_instance.web_server.id
  port             = 80
}

resource "aws_lb" "app_alb" {
  name               = "secure-app-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb_sg.id
  ]

  subnets = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]

  tags = {
    Name = "secure-app-alb"
  }
}
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_alb.arn

  port     = 80
  protocol = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

resource "aws_wafv2_web_acl" "web_acl" {
  name        = "secure-web-acl"
  description = "WAF for ALB"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "AWSManagedCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "CommonRuleSet"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "secureWebACL"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_web_acl_association" "waf_alb" {
  resource_arn = aws_lb.app_alb.arn
  web_acl_arn  = aws_wafv2_web_acl.web_acl.arn
}