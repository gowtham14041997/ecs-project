#--------------------------------------------------------------------------------
#ECS public ALB security group
#-----------------------------

variable "public_alb_sg_name" {
  type          = string
  default       = "Opstree public ALB security group"
  description   = "Public ALB SG name"
} 

variable "public_alb_sg_description" {
  type          = string
  default       = "Security group for public ALB"
  description   = "Public ALB SG description"
} 

variable "vpc_id" {
  type          = string
  description   = "VPC ID"
}

variable "public_alb_sg_tag_name" {
  type          = string
  default       = "My public ALB security group"
  description   = "Public ALB SG tag name"
} 

#--------------------------------------------------------------------------------
#ECS instance security group
#---------------------------

variable "ecs_instance_sg_name" {
  type          = string
  default       = "Opstree ECS instance security group"
  description   = "ECS instance SG name"
} 

variable "ecs_instance_sg_description" {
  type          = string
  default       = "Security group for ECS instances"
  description   = "ECS instance SG description"
} 

variable "ecs_instance_sg_tag_name" {
  type          = string
  default       = "My ECS instance security group"
  description   = "ECS instance SG tag name"
} 



