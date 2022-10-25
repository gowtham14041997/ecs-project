#--------------------------------------------------------------------------------
#ECS task definition
#-------------------

resource "aws_ecs_task_definition" "opstree_task_definition" {
  family                   = var.task_family_name
  network_mode             = var.task_network_mode
  requires_compatibilities = var.task_required_compatibilities
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = var.task_execution_role
  container_definitions    = jsonencode([
    {
      name               = var.db_container_name
      image              = var.db_container_image_repo
      memoryReservation  = 512
      essential          = true
      portMappings       = [
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
      name               = var.webapp_container_name
      image              = var.webapp_container_image_repo
      memoryReservation  = 512
      essential          = true
      links	             = ["ecs-dbcontainer"]
      portMappings       = [
        {
          containerPort = 8080
          hostPort      = 80
        }
      ]
      environment        = [
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