#--------------------------------------------------------------------------------
#ECS cluster
#-----------

variable "ecs_cluster_name" {
  type          = string
  default       = "my-ecs-cluster"
  description   = "ECS cluster name"
}   

#--------------------------------------------------------------------------------
#ECS instance role to make API calls to ECS
#------------------------------------------

variable "ecs_instance_role_name" {
  type          = string
  default       = "opstreeEcsInstanceRole"
  description   = "ECS instance role name"
} 

variable "ecs_instance_iam_profile_name" {
  type          = string
  default       = "my_ecs_instance_profile"
  description   = "ECS instance IAM profile name"
} 

#--------------------------------------------------------------------------------
#Launch template for ECS autoscaling group
#-----------------------------------------

variable "ecs_asg_launch_template_name" {
  type          = string
  default       = "My_ECS_instance_launch_template"
  description   = "ECS ASG launch template name"
} 

variable "ecs_asg_image_id" {
  type          = string
  description   = "ECS ASG image ID"
} 

variable "ecs_asg_instance_type" {
  type          = string
  description   = "ECS ASG instance type"
} 

variable "ebs_device_name" {
  type          = string
  default       = "/dev/sda1"
  description   = "EBS device name"
} 

variable "ebs_volume_size" {
  type          = number
  default       = 30
  description   = "EBS volume size"
} 

variable "ecs_asg_security_groups" {
  type          = list(string)
  description   = "ECS ASG security groups"
} 

variable "ecs_asg_resource_type" {
  type          = string
  default       = "instance"
  description   = "ECS ASG resource type"
} 

variable "ecs_asg_instance_name" {
  type          = string
  default       = "My ECS instance"
  description   = "ECS instance name"
}

#--------------------------------------------------------------------------------
#ECS autoscaling group
#---------------------

variable "ecs_asg_name" {
  type          = string
  default       = "My ECS ASG"
  description   = "ECS ASG name"
}

variable "ecs_asg_min_count" {
  type          = number
  description   = "ECS ASG minimum count"
} 

variable "ecs_asg_desired_count" {
  type          = number
  description   = "ECS ASG desired count"
} 

variable "ecs_asg_max_count" {
  type          = number
  description   = "ECS ASG maximum count"
}

variable "ecs_asg_subnet_ids" {
  type          = list(string)
  description   = "ECS ASG subnet IDs"
}

