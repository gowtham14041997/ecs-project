#--------------------------------------------------------------------------------
#VPC
#---

variable "vpc_cidr" {
  type          = string
  description   = "VPC CIDR"
}

variable "tenancy" {
  type          = string
  default       = "default"
  description   = "Instance tenancy"
}

variable "vpc_name" {
  type          = string
  default       = "My VPC"
  description   = "VPC name"
}

#--------------------------------------------------------------------------------
#AZs for public and ECS subnets
#------------------------------

variable "subnet_az" {
  type          = list(string)
  default       = ["ap-south-1a", "ap-south-1b"]
  description   = "AZs for public and ECS subnets"
}

#----------------------------------------------------------------------------------
#Public subnets
#--------------

variable "public_subnet_cidr" {
  type          = list(string)
  default       = ["10.0.1.0/24"]
  description   = "public subnet CIDR"
}

variable "public_subnet_name" {
  type          = string
  default       = "My public subnet"
  description   = "public subnet name"
}

#----------------------------------------------------------------------------------
#Private subnets for ECS cluster
#-------------------------------

variable "ecs_subnet_cidr" {
  type          = list(string)
  default       = ["10.0.2.0/24", "10.0.3.0/24"]
  description   = "ECS subnet CIDR"
}

variable "ecs_subnet_name" {
  type          = string
  default       = "My ECS subnet"
  description   = "ECS subnet name"
}
