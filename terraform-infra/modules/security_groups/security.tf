#--------------------------------------------------------------------------------
#ECS public ALB security group
#-----------------------------

resource "aws_security_group" "opstree_public_alb_security_group" {
  name        = var.public_alb_sg_name
  description = var.public_alb_sg_description
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.public_alb_sg_tag_name
  }
}

#--------------------------------------------------------------------------------
#ECS instance security group
#---------------------------

resource "aws_security_group" "ecs_instance_security_group" {
  name        = var.ecs_instance_sg_name
  description = var.ecs_instance_sg_description
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.opstree_public_alb_security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.ecs_instance_sg_tag_name 
  }
}