#--------------------------------------------------------------------------------
#Public ALB target group
#-----------------------

variable "public_alb_target_group_name" {
  type          = string
  default       = "My-public-ALB-target-group"
  description   = "Public ALB target group name"
}

variable "public_alb_target_asg_id" {
  type          = string
  description   = "Public ALB target group ASG ID"
}

variable "vpc_id" {
  type          = string
  description   = "VPC ID"
}

#--------------------------------------------------------------------------------
#Public ALB
#----------

variable "public_alb_name" {
  type          = string
  default       = "My-ECS-ALB"
  description   = "ECS ALB name"
}

variable "public_elb_type" {
  type          = string
  default       = "application"
  description   = "Public ELB type"
}

variable "public_alb_security_group_ids" {
  type          = list(string)
  description   = "Security group for public ALB"
}

variable "public_subnet_ids" {
  type          = list(string)
  description   = "Subnets for public ALB"
}