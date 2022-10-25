#--------------------------------------------------------------------------------
#Public ALB target group
#-----------------------

resource "aws_lb_target_group" "opstree_public_alb_target_group" {
    name     = var.public_alb_target_group_name
    port     = 80
    protocol = "HTTP"
    vpc_id   = var.vpc_id
}

resource "aws_autoscaling_attachment" "epam_webserver_asg_attachment" {
  autoscaling_group_name = var.public_alb_target_asg_id
  lb_target_group_arn    = aws_lb_target_group.opstree_public_alb_target_group.arn
}

#--------------------------------------------------------------------------------
#Public ALB
#----------

resource "aws_lb" "opstree_public_alb" {
    name               = var.public_alb_name
    internal           = false
    load_balancer_type = var.public_elb_type
    security_groups    = var.public_alb_security_group_ids
    subnets            = var.public_subnet_ids
}

resource "aws_lb_listener" "epam_public_alb_listener" {
  load_balancer_arn = aws_lb.opstree_public_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.opstree_public_alb_target_group.arn
  }
}