output "bastion_public_ip" {
  description = "public ip address which allocated bastion instance"
  value       = aws_eip.bastion.public_ip
}
