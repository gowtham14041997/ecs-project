#--------------------------------------------------------------------------------
#VPC
#---

resource "aws_vpc" "opstree_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = var.tenancy

  tags = {
    Name = var.vpc_name
  }
}

#----------------------------------------------------------------------------------
#Public subnets
#--------------

resource "aws_subnet" "opstree_public_subnet" {
  vpc_id                  = aws_vpc.opstree_vpc.id
  count                   = length(var.public_subnet_cidr)
  cidr_block              = element(var.public_subnet_cidr, count.index)
  availability_zone       = element(var.subnet_az, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.public_subnet_name} - ${element(var.subnet_az, count.index)}"
  }
}

#----------------------------------------------------------------------------------
#Private subnets for ECS cluster
#-------------------------------

resource "aws_subnet" "opstree_ecs_subnet" {
  vpc_id            = aws_vpc.opstree_vpc.id
  count             = length(var.ecs_subnet_cidr)
  cidr_block        = element(var.ecs_subnet_cidr, count.index)
  availability_zone = element(var.subnet_az, count.index)

  tags = {
    Name = "${var.ecs_subnet_name} - ${element(var.subnet_az, count.index)}"
  }
}
