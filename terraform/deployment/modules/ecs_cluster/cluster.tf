#--------------------------------------------------------------------------------
#ECS cluster
#-----------

resource "aws_ecs_cluster" "opstree_ecs_cluster" {
  name = var.ecs_cluster_name
}

#--------------------------------------------------------------------------------
#ECS instance role to make API calls to ECS
#------------------------------------------

resource "aws_iam_role" "ecsInstanceRole" {
    name_prefix = var.ecs_instance_role_name 
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
  name = var.ecs_instance_iam_profile_name
  role = aws_iam_role.ecsInstanceRole.name
}

#--------------------------------------------------------------------------------
#Launch template for ECS autoscaling group
#-----------------------------------------

resource "aws_launch_template" "opstree_ecs_launch_template" {
  name          = var.ecs_asg_launch_template_name
  image_id      = var.ecs_asg_image_id
  instance_type = var.ecs_asg_instance_type
  user_data     = base64encode(file("../support_files/ecs_instance_user_data.sh"))

  iam_instance_profile {
    name = aws_iam_instance_profile.opstree_ecs_instance_profile.name
  }

  block_device_mappings {
    device_name = var.ebs_device_name
    ebs {
      volume_size = var.ebs_volume_size
    }
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = var.ecs_asg_security_groups # [aws_security_group.ecs_instance_security_group.id]
  }

  tag_specifications {
    resource_type = var.ecs_asg_resource_type
    tags = {
      Name = var.ecs_asg_instance_name
    }
  }
}

#--------------------------------------------------------------------------------
#ECS autoscaling group
#---------------------

resource "aws_autoscaling_group" "opstree_ecs_asg" {
  name                      = var.ecs_asg_name

  min_size                  = var.ecs_asg_min_count
  desired_capacity          = var.ecs_asg_desired_count
  max_size                  = var.ecs_asg_max_count
  vpc_zone_identifier       = var.ecs_asg_subnet_ids 

  launch_template {
    id = aws_launch_template.opstree_ecs_launch_template.id
  }
}
