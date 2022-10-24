provider "aws" {
  region     = var.region
  profile    = "gowtham"
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

resource "aws_iam_role" "ecsInstanceRole" {
    name = "opstreeEcsInstanceRole"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecsInstanceRole_attachment" {
    role = aws_iam_role.ecsInstanceRole.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "opstree_ecs_instance_profile" {
  name = "my_ecs_instance_profile"
  role = aws_iam_role.ecsInstanceRole.name
}

resource "aws_ecs_cluster" "opstree_ecs_cluster" {
  name = "my-ecs-cluster"
}

resource "aws_security_group" "opstree_public_alb_security_group" {
  name        = "Opstree public ALB security group"
  description = "Security group for public ALB"
  vpc_id      = module.my_vpc.vpc_id

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
    Name = "My public ALB security group"
  }
}

#--------------------------------------------------------------------------------
#ECS instance security group
#------------------------

resource "aws_security_group" "ecs_instance_security_group" {
  name        = "Opstree ECS instance security group"
  description = "Security group for ECS instances"
  vpc_id      = module.my_vpc.vpc_id

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
    Name = "My public ALB security group"
  }
}

resource "aws_launch_template" "opstree_ecs_launch_template" {
  name          = "My_ECS_instance_launch_template"
  image_id      = "ami-08db0e1881e30be69"
  instance_type = "t3.medium"
  user_data     = base64encode(file("../support_files/ecs_instance_user_data.sh"))

  iam_instance_profile {
    name = aws_iam_instance_profile.opstree_ecs_instance_profile.name
  }

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 30
    }
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.ecs_instance_security_group.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "My appserver instance"
    }
  }
}

#--------------------------------------------------------------------------------
#ECS autoscaling group
#---------------------

resource "aws_autoscaling_group" "opstree_ecs_asg" {
  name                      = "My ECS ASG"

  min_size                  = 2
  desired_capacity          = 2
  max_size                  = 2
  vpc_zone_identifier       = module.my_vpc.ecs_subnet_ids

  launch_template {
    id = aws_launch_template.opstree_ecs_launch_template.id
  }
}


resource "aws_ecs_task_definition" "service" {
  family = "webapp"
  network_mode = "bridge"
  requires_compatibilities = ["EC2"]
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = "arn:aws:iam::335961360975:role/dockerhub-role"
  container_definitions = jsonencode([
    {
      name      = "ecs-dbcontainer"
      image     = "335961360975.dkr.ecr.ap-south-1.amazonaws.com/mysql"
      memoryReservation    = 512
      essential = true
      portMappings = [
        {
          containerPort = 3306
          hostPort      = 3306
        }
      ]
      environment = [
        {
          name  = "MYSQL_DATABASE"
          value = "employeedb"
        },
        {
          name   = "MYSQL_HOST"
          value  = "localhost"
        },
        {
          name   = "MYSQL_ROOT_PASSWORD"
          value  = "password"
        }
      ]
    },
    {
      name      = "ecs-webcontainer"
      image     = "335961360975.dkr.ecr.ap-south-1.amazonaws.com/webapp"
      memory    = 512
      essential = true
      links	= ["ecs-dbcontainer"]
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 80
        }
      ]
      environment = [
        {
          name  = "MYSQL_DATABASE"
          value = "employeedb"
        },
        {
          name   = "MYSQL_HOST"
          value  = "localhost"
        },
        {
          name   = "MYSQL_ROOT_PASSWORD"
          value  = "password"
        }
      ]
    }
  ])

  volume {
    name      = "my-storage"
    host_path = "/ecs/my-storage"
  }
}




