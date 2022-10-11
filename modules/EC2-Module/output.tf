output "default_sg_id" {
    value = aws_security_group.default_sg.id
}
output "ec2_template_id" {
    value = aws_launch_template.ec2_template.id
}