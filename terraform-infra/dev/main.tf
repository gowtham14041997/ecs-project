provider "aws" {
  region     = var.region
}

module "my_vpc" {
  source                = "../modules/vpc"

  #VPC
  vpc_cidr              = "10.0.0.0/16"

  #Public subnet CIDR for bastion host
  public_subnet_cidr    = slice(var.subnet_cidrs, 0, 2)

  #Private subnet CIDR for EKS cluster
  ecs_subnet_cidr       = slice(var.subnet_cidrs, 2, 4)
}

module "my_route_table" {
  source                      = "../modules/route_table"

  #VPC ID for internet gateway
  vpc_id                      = module.my_vpc.vpc_id

  #Public subnet for NAT gateway
  public_subnet_id            = module.my_vpc.public_subnet_id

  #Gateway IDs to create public and private route table
  gateway_id                  = [module.my_route_table.igw_id, module.my_route_table.natgw_id]

  #Public subnets to be associated with public route table
  public_subnet_ids_count     = module.my_vpc.public_subnet_ids_count
  public_subnet_ids           = module.my_vpc.public_subnet_ids

  #Private subnets to be associated with private route table
  ecs_subnet_ids_count        = module.my_vpc.ecs_subnet_ids_count
  ecs_subnet_ids              = module.my_vpc.ecs_subnet_ids
}

module "my_security_groups" {
  source                      = "../modules/security_groups"

  #VPC ID for security groups
  vpc_id                      = module.my_vpc.vpc_id
}

module "my_ecs_cluster" {
  source                      = "../modules/ecs_cluster"

  #ECS ASG configuration
  ecs_asg_image_id            = "ami-08db0e1881e30be69"
  ecs_asg_instance_type       = "t3.medium"

  ecs_asg_min_count           = 2
  ecs_asg_desired_count       = 2
  ecs_asg_max_count           = 2

  #Subnets and security groups for ECS ASG
  ecs_asg_subnet_ids          = module.my_vpc.ecs_subnet_ids
  ecs_asg_security_groups     = module.my_security_groups.ecs_instance_security_group_id
}

module "my_ecs_tasks_and_service" {
  source                        = "../modules/ecs_tasks_and_service"

  #ECS task definition
  task_required_compatibilities = ["EC2"]
  task_cpu                      = 1024
  task_memory                   = 2048
}


