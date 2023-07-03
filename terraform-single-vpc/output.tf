output "vpc_id" {
value = "${aws_vpc.main.id}"
}

output "subnet_id_public-1" {
 value = "${aws_subnet.subnet-public-1.id}"
}

output "subnet_id_public-2" {
 value = "${aws_subnet.subnet-public-2.id}"
}


output "subnet_id_private-5" {
 value = "${aws_subnet.subnet-private-5.id}"
}

output "subnet_id_private-6" {
 value = "${aws_subnet.subnet-private-6.id}"
}

output "subnet_id_private-7" {
 value = "${aws_subnet.subnet-private-7.id}"
}

output "subnet_id_private-8" {
 value = "${aws_subnet.subnet-private-8.id}"
}

output "subnet_id_private-9" {
 value = "${aws_subnet.subnet-private-9.id}"
}
output "jumbox_public_ip" {
   value = "${aws_instance.jumpbox.public_ip}"
}

output "private_key" {
  value     = tls_private_key.key.private_key_pem
  sensitive = true
}
