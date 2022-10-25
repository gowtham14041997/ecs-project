variable "ecr_repo_name" {
  type          = list(string)
  default       = ["webapp", "mysql"]
  description   = "ECR repository name"
}