terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


resource "aws_instance" "instances" {
  count           = var.num_instances
  ami             = data.aws_ami.tf-ami.id
  instance_type   = var.ec2_type
  security_groups = ["tfassigment-sg"]
  key_name        = var.key_name
  user_data       = <<-EOF
      #! /bin/bash
      sudo yum update -y
      sudo yum install -y httpd
      sudo chkconfig httpd on
      sudo service httpd start 
      echo "<h1>Hello World!</h1>" | sudo tee /var/html/index.html
      EOF

    tags = {
      Name = "${var.ec2_name}-instance-${count.index}"
  }


 
}
  resource "null_resource" "provisioners-local-execs" {
    provisioner "local-exec" {
      command = "echo ${join(",", aws_instance.instances.*.public_ip)} > public.txt"

    }

    provisioner "local-exec" {
      command = "echo ${join(",", aws_instance.instances.*.private_ip)} > private.txt"

    }

  }














resource "aws_security_group" "tf-sec-group" {
  name = "tf-assigment-sg"
  tags = {
    "Name" = "tf-assigment-sg"
  }

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = -1 # -1 means all protocols
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }






}

  data "aws_ami" "tf-ami" {
      most_recent = true
      owners = ["amazon"]

      filter {
        name   = "Name"
        values = ["Amzn2-ami-hvm*"]
  }
}



