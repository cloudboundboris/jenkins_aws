data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]


}

resource "aws_key_pair" "key-pair-1" {
  key_name   = "key-pair-1"
  public_key = file(var.PUBLIC_KEY_PATH)
  tags = {
    Name        = "${var.PROJECT_NAME}_key-pair"
    Terraform   = "true"
    Environment = "dev"
  }

}

resource "aws_instance" "instance1" {
  depends_on                  = [aws_efs_mount_target.efs-mt-1]
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.ec2-sg.id]
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.cidr1.id
  key_name                    = aws_key_pair.key-pair-1.id

  user_data = base64encode(templatefile("user-data-instance1.tpl",
  { aws_efs_id = aws_efs_file_system.efs1.id }))


  connection {
    user        = var.EC2_USER
    private_key = file[var.PRIVATE_KEY_PATH]
  }
  tags = {
    Name        = "${var.PROJECT_NAME}_instance1"
    Terraform   = "true"
    Environment = "dev"

  }

}