module "elb" {
  source          = "terraform-aws-modules/elb/aws"
  name            = "elb1"
  subnets         = [aws_subnet.cidr1.id]
  security_groups = [aws_security_group.elb.id]
  internal        = false


  listener = [
    {
      instance_port     = 8080
      instance_protocol = "HTTP"
      lb_port           = 80
      lb_protocol       = "HTTP"
    },
    {
      instance_port      = 8080
      instance_protocol  = "HTTP"
      lb_port            = 443
      lb_protocol        = "HTTPS"
      ssl_certificate_id = aws_acm_certificate.cert1.arn

    }

  ]


  health_check = {
    target              = "TCP:8080"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5

  }

  number_of_instances = 1
  instances           = [aws_instance.instance1.id]

  tags = {
    Name        = "${var.PROJECT_NAME}_key-elb1"
    Terraform   = "true"
    Environment = "dev"
  }
}