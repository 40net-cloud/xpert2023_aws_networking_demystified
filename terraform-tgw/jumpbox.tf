resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "jumpbox_key" {
  key_name   = "${var.PREFIX}-${var.environment}-jumpbox_key_${var.REGION}"
  public_key = tls_private_key.key.public_key_openssh
}  
  
  
  data "aws_ami" "ubuntu_ami" {
    most_recent = true
    owners      = ["679593333241"]

    filter {
      name   = "name"
      values = ["ubuntu*hvm-ssd*22.04*amd*"]
    }
  }


resource "aws_instance" "jumpbox" {
  ami           = "${data.aws_ami.ubuntu_ami.image_id}"
  instance_type = "t2.micro"
  key_name      = "${aws_key_pair.jumpbox_key.key_name}"
  subnet_id     = "${aws_subnet.egresspublicsubnetaz1.id}"
  vpc_security_group_ids      = [aws_security_group.allow_custom.id]
  associate_public_ip_address = true

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
EOF

  tags = {
    Name = "${var.PREFIX}-${var.environment}-ec2-jumpbox"
  }
}

resource "aws_security_group" "allow_custom" {
  name        = "allow_custom"
  description = "Allow SSH and HTTP8080 inbound traffic"
  vpc_id      = aws_vpc.vpc-spoke-egress.id

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTP8080"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["10.0.0.0/8"]
  }

  ingress {
    description      = "HTTP8080"
    from_port        = 8090
    to_port          = 8090
    protocol         = "tcp"
    cidr_blocks      = ["10.0.0.0/8"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_custom"
  }
}
