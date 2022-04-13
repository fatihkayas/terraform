provider "aws" {
  region  = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.8.0"
    }
  }
}

locals {
  mytag ="oliver-local-name"
}



resource "aws_instance" "tf-ec2" {
  ami           = var.ec2_ami
  instance_type = var.ec2_type
  key_name      = "himmel"
  tags = {
    Name = "${local.mytag}-come from locals"
    #"${var.ec2_name}-instance"
  }
}



resource "aws_s3_bucket" "tf-s3" {
  bucket = "${var.s3_bucket_name}-${count.index}"
  count = var.num_of_buckets


}