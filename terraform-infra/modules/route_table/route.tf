#--------------------------------------------------------------------------------
#Internet gateway
#----------------

resource "aws_internet_gateway" "opstree_igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = var.igw_name
  }
}

#--------------------------------------------------------------------------------
#NAT gateway
#-----------

resource "aws_eip" "opstree_eip_natgw" {
  vpc = true
}

resource "aws_nat_gateway" "opstree_natgw" {
  allocation_id = aws_eip.opstree_eip_natgw.id
  subnet_id     = var.public_subnet_id

  tags = {
    Name = var.natgw_name
  }
}

#--------------------------------------------------------------------------------
#Route table
#-----------

resource "aws_route_table" "opstree_route_table" {
    vpc_id = var.vpc_id
    count   = length(var.gateway_id)

    route {
        cidr_block = var.allow_all_ipv4_cidr
        gateway_id = element(var.gateway_id, count.index)
    }

    tags = {
        Name = "My ${element(var.route_table_name, count.index)} route table"
    }
}

#--------------------------------------------------------------------------------
#Public route table association
#------------------------------

data "aws_route_table" "public_route_table_id" {
  filter {
    name = "tag:Name"
    values = ["My public route table"]
  }
  depends_on = [
    aws_route_table.opstree_route_table
  ]
}

resource "aws_route_table_association" "opstree_public_route_table_association" {
  count          = var.public_subnet_ids_count
  subnet_id      = element(var.public_subnet_ids, count.index)
  route_table_id = data.aws_route_table.public_route_table_id.id
}

#--------------------------------------------------------------------------------
#Private route table association
#-------------------------------

data "aws_route_table" "private_route_table_id" {
  filter {
    name = "tag:Name"
    values = ["My private route table"]
  }
  depends_on = [
    aws_route_table.opstree_route_table
  ]
}

resource "aws_route_table_association" "opstree_ecs_route_table_association" {
  count          = var.ecs_subnet_ids_count
  subnet_id      = element(var.ecs_subnet_ids, count.index)
  route_table_id = data.aws_route_table.private_route_table_id.id
}

