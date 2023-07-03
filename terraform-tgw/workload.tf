##############################################################################################################
#
# Linux VM
# Terraform deployment template for AWS
#
##############################################################################################################

##############################################################################################################
# Linux VM - Spoke 1
##############################################################################################################

resource "aws_network_interface" "spoke1-lnx-nic" {
  description = "${var.PREFIX}-spoke1-lnx"
  subnet_id   = aws_subnet.spoke1privatesubnetaz1.id
  tags = {
    Name = "${var.PREFIX}-spoke1-lnx-nic-int"
  }
}

resource "aws_network_interface_sg_attachment" "spoke1-lnx-nicsg" {
  depends_on           = [aws_network_interface.spoke1-lnx-nic]
  security_group_id    = aws_security_group.spoke1_allow_all.id
  network_interface_id = aws_network_interface.spoke1-lnx-nic.id
}

resource "aws_instance" "spoke1-lnx-vm" {
  //it will use region, architect, and license type to decide which ami to use for deployment
  ami               = data.aws_ami.lnx_ami.id
  instance_type     = var.lnx_vmsize
  availability_zone = local.az1
  key_name          = "${aws_key_pair.jumpbox_key.key_name}"
  user_data = templatefile("${path.module}/customdata-lnx.tftpl", {
    hostname = "${var.PREFIX}-spoke1-lnx-vm"
    username = var.USERNAME
    password = var.PASSWORD
  })

  root_block_device {
    volume_type = "gp2"
    volume_size = "50"
  }

  network_interface {
    network_interface_id = aws_network_interface.spoke1-lnx-nic.id
    device_index         = 0
  }

  tags = {
    Name = "${var.PREFIX}-spoke1-lnx-vm"
  }
}

##############################################################################################################
# Linux VM Spoke 2
##############################################################################################################

resource "aws_network_interface" "spoke2-lnx-nic" {
  description = "${var.PREFIX}-spoke1-lnx"
  subnet_id   = aws_subnet.spoke2privatesubnetaz1.id
  tags = {
    Name = "${var.PREFIX}-spoke2-lnx-nic-int"
  }
}

resource "aws_network_interface_sg_attachment" "spoke2-lnx-nicsg" {
  depends_on           = [aws_network_interface.spoke2-lnx-nic]
  security_group_id    = aws_security_group.spoke2_allow_all.id
  network_interface_id = aws_network_interface.spoke2-lnx-nic.id
}

resource "aws_instance" "spoke2-lnx-vm" {
  //it will use region, architect, and license type to decide which ami to use for deployment
  ami               = data.aws_ami.lnx_ami.id
  instance_type     = var.lnx_vmsize
  availability_zone = local.az1
  key_name          = "${aws_key_pair.jumpbox_key.key_name}"
  user_data = templatefile("${path.module}/customdata-lnx.tftpl", {
    hostname = "${var.PREFIX}-spoke2-lnx-vm"
    username = var.USERNAME
    password = var.PASSWORD
  })

  root_block_device {
    volume_type = "gp2"
    volume_size = "50"
  }

  network_interface {
    network_interface_id = aws_network_interface.spoke2-lnx-nic.id
    device_index         = 0
  }

  tags = {
    Name = "${var.PREFIX}-spoke2-lnx-vm"
  }
}
