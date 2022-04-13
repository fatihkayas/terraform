output "ec2-public-ip" {
  value = aws_instance.instances.*.public_ip

}

