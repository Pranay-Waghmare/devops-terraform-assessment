locals {
  ec2_instances = {
    nginx1 = {
      subnet_id = aws_subnet.public1.id
      name      = "nginx-public-1"
    }

    nginx2 = {
      subnet_id = aws_subnet.public2.id
      name      = "nginx-public-2"
    }
  }
}

resource "aws_instance" "nginx" {
  for_each = local.ec2_instances

  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id = each.value.subnet_id

  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = file("user-data.sh")

  tags = {
    Name = each.value.name
  }
}
