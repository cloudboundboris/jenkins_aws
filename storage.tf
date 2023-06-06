resource "aws_efs_file_system" "efs1" {
  creation_token   = "efs1"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = "true"

  tags = {
    Name        = "${var.PROJECT_NAME}_efs1"
    Terraform   = "true"
    Environment = "dev"

  }
}

resource "aws_efs_mount_target" "efs-mt-1" {
  file_system_id  = aws_efs_file_system.efs1.id
  subnet_id       = aws_subnet.cidr1.id
  security_groups = [aws_security_group.efs-sg.id]

}


