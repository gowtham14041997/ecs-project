output "ecs_instance_security_group_id" {
    value = split(",", aws_security_group.ecs_instance_security_group.id)
}

output "public_alb_security_group_id" {
    value = split(",", aws_security_group.opstree_public_alb_security_group.id)
}