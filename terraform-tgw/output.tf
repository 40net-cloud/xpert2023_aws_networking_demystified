output "private_key" {
  value     = tls_private_key.key.private_key_pem
  sensitive = true
}