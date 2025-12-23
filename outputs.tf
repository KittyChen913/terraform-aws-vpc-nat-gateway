# ============================================================================
# Output
# ============================================================================

# Output：輸出 Public Instance Public IP
output "instance_public_ip" {
  value       = aws_instance.public.public_ip
  description = "Public instance 的 Public IP"
}

# Output：輸出 Private Instance Private IP
output "instance_private_ip" {
  value       = aws_instance.private.private_ip
  description = "Private instance 的 Private IP"
}

# Output：輸出 SSH 登入命令
output "ssh_command" {
  value       = "ssh -i ~/.ssh/terraform-ec2 ec2-user@${aws_instance.public.public_ip}"
  description = "連接到 public instance 的 SSH 命令"
}

# Output：輸出透過 Bastion 連接 Private Instance 的 SSH 命令
output "ssh_command_via_bastion" {
  value       = <<-EOT
ssh -o "ProxyCommand=ssh -i ~/.ssh/terraform-ec2 -W %h:%p ec2-user@${aws_instance.public.public_ip}" -i ~/.ssh/terraform-ec2 ec2-user@${aws_instance.private.private_ip}
EOT
  description = "使用 ProxyCommand 連接到 private instance 的 SSH 命令"
}
