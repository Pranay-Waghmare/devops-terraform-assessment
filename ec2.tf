locals {
  ec2_instances = {
    nginx1 = {
      subnet_id = aws_subnet.private1.id
      name      = "nginx-private-1"
    }

    nginx2 = {
      subnet_id = aws_subnet.private2.id
      name      = "nginx-private-2"
    }
  }
}

resource "aws_instance" "nginx" {
  for_each = local.ec2_instances

  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id = each.value.subnet_id

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = file("user-data.sh")

  tags = {
    Name = each.value.name
  }
}
