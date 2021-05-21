provider "aws" {
  region  = "us-west-1"
  profile = var.profile
}

module "test_module" {
  source = "./test_module"
  vpc_id = aws_vpc.test_vpc.id
}

resource "aws_vpc" "test_vpc" {
  assign_generated_ipv6_cidr_block = false
  cidr_block                       = "10.0.0.0/16"
  enable_dns_hostnames             = true
  enable_dns_support               = true
  instance_tenancy                 = "default"
  tags = {
    "Name" = "main_vpc"
  }
}

resource "aws_security_group" "bad_sg" {
  name        = "bad_sg"
  description = "bad man"
  vpc_id      = aws_vpc.test_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["1.2.3.4/32"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "good_sg" {
  name        = "good_sg"
  description = "good security group"
  vpc_id      = aws_vpc.test_vpc.id
}

resource "aws_security_group_rule" "bad_rule" {
  type              = "ingress"
  from_port         = "3306"
  to_port           = "3306"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.good_sg.id
}

resource "aws_security_group_rule" "good_rule" {
  type              = "ingress"
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.good_sg.id
}

variable "profile" {
  type        = string
  description = "profile name.  not setting will use your default IAM profile"
  default     = ""
}