output "ecs_instance_security_group_id" {
    value = split(",", aws_security_group.ecs_instance_security_group.id)
}