
resource "aws_instance" "wwwdemo3" {
  ami           = "${data.aws_ami.ubuntu_ami.image_id}"
  instance_type = "t2.micro"
  key_name      = "${aws_key_pair.jumpbox_key.key_name}"
  subnet_id     = "${aws_subnet.subnet-private-6.id}"
  vpc_security_group_ids      = [aws_security_group.allow_custom.id]
  associate_public_ip_address = false

  root_block_device {
    volume_size           = "20"
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true
  }


  user_data = <<EOF
#!/bin/bash
apt-get update
apt-get install -y docker.io jq net-tools
sudo docker run -d -p 8080:80 nginx
sudo docker run -d -p 8090:80 nginx

EOF

  tags = {
    Name = "${var.prefix}-${var.environment}-ec2-wwwdemo3"
  }
}

