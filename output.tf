output "ec2_public_ip" {
  description = "EC2 Public IP"
  value       = aws_instance.instance1.public_ip
}


output "aws_efs_id" {
  description = "EFS ID"
  value       = aws_efs_file_system.efs1.id

}

output "elb_dns_name" {
  description = "ELB DNS Name"
  value       = module.elb.elb_dns_name
}








