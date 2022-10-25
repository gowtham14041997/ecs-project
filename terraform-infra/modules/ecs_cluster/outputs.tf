output "ecs_cluster_id" {
    value = aws_ecs_cluster.opstree_ecs_cluster.id
}

output "ecs_cluster_asg_id" {
    value = aws_autoscaling_group.opstree_ecs_asg.id
}