variable "region" {
  type          = string
  default       = "ap-south-1"
  description   = "AWS VPC region"
}

variable "ecr_repo_name" {
  type          = list(string)
  default       = ["webapp", "mysql"]
  description   = "ECR repository name"
}