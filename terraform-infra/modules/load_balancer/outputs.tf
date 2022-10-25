output "public_alb_dns" {
    value = aws_lb.opstree_public_alb.dns_name
}