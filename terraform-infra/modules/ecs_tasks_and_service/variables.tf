#--------------------------------------------------------------------------------
#ECS task definition
#-------------------

variable "task_family_name" {
  type          = string
  default       = "webapp"
  description   = "ECS task family name"
} 

variable "task_network_mode" {
  type          = string
  default       = "bridge"
  description   = "ECS task network mpde"
} 

variable "task_required_compatibilities" {
  type          = list(string)
  description   = "ECS task required compatibilities"
} 

variable "task_cpu" {
  type          = number
  description   = "ECS task CPU"
} 

variable "task_memory" {
  type          = number
  description   = "ECS task memory"
} 

variable "task_execution_role" {
  type          = string
  default       = "arn:aws:iam::335961360975:role/dockerhub-role"
  description   = "ECS task execution role"
} 

variable "db_container_name" {
  type          = string
  default       = "ecs-dbcontainer"
  description   = "DB container name"
} 

variable "db_container_image_repo" {
  type          = string
  default       = "335961360975.dkr.ecr.ap-south-1.amazonaws.com/mysql"
  description   = "DB container image repository url"
} 

variable "webapp_container_name" {
  type          = string
  default       = "ecs-webcontainer"
  description   = "Webapp container name"
} 

variable "webapp_container_image_repo" {
  type          = string
  default       = "335961360975.dkr.ecr.ap-south-1.amazonaws.com/webapp"
  description   = "Webapp container image repository url"
} 
