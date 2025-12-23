# ============================================================================
# EC2 Instance
# ============================================================================

# Public EC2 實例配置
resource "aws_instance" "public" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.my_key.key_name
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.main.id]

  tags = {
    Name = "my-public-instance"
  }
}

# Private EC2 實例配置
resource "aws_instance" "private" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.my_key.key_name
  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.main.id]

  tags = {
    Name = "my-private-instance"
  }
}
