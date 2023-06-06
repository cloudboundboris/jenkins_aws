resource "aws_security_group" "ec2-sg" {
  name   = "${var.PROJECT_NAME}-ec2-sg1"
  vpc_id = aws_vpc.vpc1.id


  dynamic "ingress" {
    for_each = var.PORTS_EC2
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name        = "${var.PROJECT_NAME}-ec2-sg1"
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_security_group" "efs-sg" {
  name   = "${var.PROJECT_NAME}-efs1-sg"
  vpc_id = aws_vpc.vpc1.id


  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.ec2-sg.id]
  }
  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2-sg.id]
  }


  tags = {
    Name        = "${var.PROJECT_NAME}-efs1-sg"
    Terraform   = "true"
    Environment = "dev"
  }
}